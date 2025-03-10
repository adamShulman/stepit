//import "dart:js";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stepit/classes/challenge_singleton.dart";

class User {
  
  String username;
  int uniqueNumber;
  String gameType;
  int level;
  int points;
  Timestamp joinedTime = Timestamp.now();

  User({
    required this.username,
    required this.uniqueNumber,
    required this.gameType,
    required this.level,
    required this.points
  });

  // subcollection to save daily steps every 15 minutes.

  // User(
  //     {required this.username,
  //     required this.uniqueNumber,
  //     required this.gameType, required this.level});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uniqueNumber': uniqueNumber,
      'gameType': gameType,
      'level' : level,
      'joinedTime': joinedTime,
      'points': points
      // 'dailyStepsList': dailyStepsList,
    };
  }

  // a static method to create a user from a map
  User.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        uniqueNumber = map['uniqueNumber'],
        gameType = map['gameType'],
        level = map['level'],
        joinedTime = map['joinedTime'],
        points = map['points'] ?? 0;
  // dailyStepsList = map['dailyStepsList'];

  // comparing two users
  @override
  bool operator ==(Object other) {
    return (other is User) && other.uniqueNumber == uniqueNumber;
  }

  // hashCode for the user
  @override
  int get hashCode => uniqueNumber.hashCode;

  @override
  String toString() {
    return 'User{username: $username, uniqueNumber: $uniqueNumber, gameType: $gameType, joinedTime: $joinedTime}';
  }
}

// User provider
class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

Future<void> saveUser(String username, int uniqueNumber, String gameType, int level, int points) async {

  User user = User(username: username, uniqueNumber: uniqueNumber, gameType: gameType, level: level, points: points);

  // Save to Firebase
  await FirebaseFirestore.instance.collection('users').doc(uniqueNumber.toString().padLeft(6, '0')).set(user.toMap());

  // Save to shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setInt('uniqueNumber', user.uniqueNumber);
  await prefs.setString('gameType', user.gameType);
  await prefs.setInt('level', user.level);
  await prefs.setInt('points', user.points);

  LazySingleton.instance.currentUser = user;

  // Update user provider
  // Provider.of<UserProvider>(context, listen: false).setUser(user);

  // return user;
}

// Future<User?> loadUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? username = prefs.getString('username');
//   int? uniqueNumber = prefs.getInt('uniqueNumber');
//   String? gameType = prefs.getString('gameType');
//   int? level = prefs.getInt('level');
//   int points = prefs.getInt('points') ?? 0;

//   if (username != null && uniqueNumber != null && gameType != null && level != null) {
//     User user = User(username: username, uniqueNumber: uniqueNumber, gameType: gameType, level: level, points: points);
//     Provider.of<UserProvider>(context, listen: false).setUser(user);
//     return user;
//   } else {
//     return null;
//   }
// }