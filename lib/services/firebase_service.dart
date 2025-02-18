
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepit/classes/challenge.dart';
import 'package:stepit/classes/user.dart';

class FirestoreService {

  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Fetch all users
  Stream<List<Map<String, dynamic>>> fetchUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  // Add a new user
  Future<void> addUser(String name, String email) async {
    await _firestore.collection('users').add({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fetch challenges
  Stream<List<Challenge>> fetchChallenges() {
    return _firestore.collection('games').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
    });
  }

  // Start a challenge
  Future<void> startChallenge(String userId, String challengeId) async {
    await _firestore.collection('user_challenges').add({
      'userId': userId,
      'challengeId': challengeId,
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
    });
  }

  // Complete a challenge
  Future<void> completeChallenge(String userChallengeId) async {
    await _firestore.collection('user_challenges').doc(userChallengeId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // Future<void> loadGames(User user) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('games')
  //       .where('type', isEqualTo: user.gameType)
  //       .where('level', isEqualTo: user.level.toString())
  //       .get();
  //   List<DocumentSnapshot> docs = querySnapshot.docs;
  //   List<Game>? games = [];
  //   games = docs.map((doc) => Game.fromDocument(doc)).cast<Game>().toList();

  //   // Get today's games
  //   List<Game> todaysGames = await getTodaysGames(games, user);

  //   // Save today's games to the user's collection
  //   //await saveTodaysGames(todaysGames, user);

  //   Provider.of<GameProvider>(context, listen: false).setGames(todaysGames);
  //   notifyListeners();
  // }
}
