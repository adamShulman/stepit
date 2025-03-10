
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
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


  // Add a new user
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

//   Future<List<Challenge>> fetchChallengesOnceFromStream() async {
//     final snapshot = await _firestore.collection('games').snapshots().first;
//     return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
// }



//   // Fetch challenges
//   Stream<List<Challenge>> fetchChallenges() {
//     return _firestore.collection('games').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();
//     });
//   }

  Future<List<Challenge>> fetchUserChallenges(int userId) async {
    
    final snapshot = await _firestore.collection('users')
      .doc(userId.toString().padLeft(6, '0'))
      .collection('userGames')
      .get();

    return snapshot.docs.map((doc) => Challenge.fromJson(doc.data())).toList();

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

  // Future<List<Game>> getTodaysGames(List<Game> allGames, User user) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedDate = prefs.getString('date');
  //   String today = DateTime.now().toIso8601String().split('T')[0];

  //   if (storedDate != today) {
  //     CollectionReference userGames = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uniqueNumber.toString().padLeft(6, '0'))
  //         .collection('userGames');

  //     // Fetch the user's completed games
  //     QuerySnapshot completedGamesSnapshot =
  //         await userGames.where('Completed', isEqualTo: true).get();
  //     List<String> completedGameIds =
  //         completedGamesSnapshot.docs.map((doc) => doc.id).toList();

  //     // Filter the games that have not been completed
  //     List<Game> filteredGames = allGames
  //         .where((game) => !completedGameIds.contains(game.id))
  //         .toList();

  //     // Shuffle and select the filtered games
  //     filteredGames.shuffle();
  //     List<Game> games = filteredGames.take(3).toList();
  //     List<String> gameIds = games.map((game) => game.id).toList();

  //     await prefs.setString('date', today);
  //     await prefs.setStringList('gameIds', gameIds);
  //     await saveTodaysGames(games, user);
  //     return games;
  //   } else {
  //     List<String> storedGameIds = prefs.getStringList('gameIds') ?? [];
  //     return allGames.where((game) => storedGameIds.contains(game.id)).toList();
  //   }
  // }
// }

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
