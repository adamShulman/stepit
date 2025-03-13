
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/user.dart';

class FirestoreService {

  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<User>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    });
  }

  Stream<int> getUserPointsStream(int userId) {
    return _firestore.collection('users').where('uniqueNumber', isEqualTo: userId).snapshots().map((snapshot) {
      return User.fromMap(snapshot.docs.first.data()).points;
    });
  }

  Stream<User> getUserStream(int userId)  {
    return _firestore.collection('users').where('uniqueNumber', isEqualTo: userId).snapshots().map((snapshot) {
      return User.fromMap(snapshot.docs.first.data());
    });
  }

  Future<User> getUser(int userId) async {
    final snapshot = await _firestore.collection('users').where('uniqueNumber', isEqualTo: userId).get();
    return User.fromMap(snapshot.docs.first.data());
  }

  Future<List<User>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
  }

  Future<void> addUser(String name, String email) async {
    await _firestore.collection('users').add({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Challenge>> fetchChallengesOnce() async {
    final snapshot = await _firestore.collection('games').get();
    return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
  }

  Future<List<Challenge>> fetchChallengesOnceRemoveResumed(String userId) async {

    final userChallengesSnapshot = await _firestore.collection('users')
      .doc(userId.toString().padLeft(6, '0'))
      .collection(ChallengeStatus.active.challengeFirestoreCollectionRef)
      .get();
    
    // final games = gamesSnapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
    // final userGamesIds = userGamesSnapshot.docs.map((doc) => doc['identifier']).toList();
    // final gamesSnapshot = await _firestore.collection('games').where('identifier', isNotEqualTo: userGamesIds).get();

    final userChallengesIds = userChallengesSnapshot.docs.map((doc) => doc['identifier']).toSet();

    if (userChallengesIds.isEmpty) {
      final challengesSnapshot = await _firestore.collection('games').get();
      return challengesSnapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
    }

    if (userChallengesIds.length <= 10) {

      final gamesSnapshot = await _firestore
          .collection('games')
          .where('identifier', whereNotIn: userChallengesIds)
          .get();
      return gamesSnapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();

    } else {
      
      final challengesSnapshot = await _firestore.collection('games').get();

      final filteredChallenges = challengesSnapshot.docs.where((doc) {
        final identifier = doc['identifier'];
        return !userChallengesIds.contains(identifier);
      }).toList();

      return filteredChallenges.map((doc) => Challenge.fromJson(doc.data())).toList();

    }
  }

  Future<List<Challenge>> fetchUserChallenges(String userId) async {
    
    final snapshot = await _firestore.collection('users')
      .doc(userId.toString().padLeft(6, '0'))
      .collection(ChallengeStatus.active.challengeFirestoreCollectionRef)
      .get();

    return snapshot.docs.map((doc) => Challenge.fromJson(doc.data(), challengeStatus: ChallengeStatus.paused)).toList();

  }


  void updatePointsForUser(int points, String userId) {

    try {
      
      _firestore
        .collection("users")
        .doc(userId)
        .update({'points': FieldValue.increment(points)});

    } catch (error) {
      log(error.toString());
    }
  }

  void updateChallengeLocation(double lat, double lng, String userId, String collectionReference, int challengeId) {
    
    try {

      final location = {
        'latitude': lat,
        'longitude': lng,
        'timestamp': FieldValue.serverTimestamp(),
      };

      _firestore.collection("users")
        .doc(userId)
        .collection(collectionReference)
        .doc("game_$challengeId")
        .collection("locations").add(location);

      log("🔥 Challenge location updated in Firestore!");  
    } catch (e) {
      log("❌ Error updating Firestore: $e");
    }
  }

  void updateUserChallenge(Map<String, dynamic> jsonData, String userId, String collectionReference, int challengeId) {

    _firestore
      .collection("users")
      .doc(userId)
      .collection(collectionReference)
      .doc("game_$challengeId")
      .set(jsonData, SetOptions(merge: true));

  }

  void removeFromFirestoreChallengeToResume(String userId, String collectionReference, int challengeId) async {

    final fireStoreResumeChallengeReference = _firestore
      .collection("users")
      .doc(userId)
      .collection(ChallengeStatus.active.challengeFirestoreCollectionRef)
      .doc("game_$challengeId");

      await removeFromFirestoreChallengeToResumeLocationsSubCollection(fireStoreResumeChallengeReference, userId, collectionReference, challengeId);

      fireStoreResumeChallengeReference.delete();

  }

  Future<void> removeFromFirestoreChallengeToResumeLocationsSubCollection(DocumentReference<Map<String, dynamic>> fireStoreChallengeReference, String userId, String collectionReference, int challengeId) async {

    final subCollectionRef = fireStoreChallengeReference.collection('locations');

    final subDocs = await subCollectionRef.get();

    for (var doc in subDocs.docs) {
      await moveChallengeLocationsSubCollection(doc, userId, collectionReference, challengeId);
      await doc.reference.delete();
    }

  }

  Future<void> moveChallengeLocationsSubCollection(QueryDocumentSnapshot<Map<String, dynamic>> doc, String userId, String collectionReference, int challengeId) async {

    final fireStoreChallengeReference = FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection(collectionReference)
      .doc("game_$challengeId");

      final subCollectionRef = fireStoreChallengeReference.collection('locations');

      await subCollectionRef.add(doc.data());
  }

  Future<void> clearLocationsSubCollection(String userId, String collectionReference, int challengeId) async {

    final collection = await _firestore
        .collection("users")
        .doc(userId)
        .collection(collectionReference)
        .doc("game_$challengeId")
        .collection("locations").get();
    
    final batch = _firestore.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    
    return batch.commit();
  }


  Future<void> startChallenge(String userId, String challengeId) async {
    await _firestore.collection('user_challenges').add({
      'userId': userId,
      'challengeId': challengeId,
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeChallenge(String userChallengeId) async {
    await _firestore.collection('user_challenges').doc(userChallengeId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }
}
