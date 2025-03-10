
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/user.dart';

// class ChallengeSingleton {

//   ChallengeSingleton._privateConstructor();

//   static ChallengeSingleton? _instance;

//   factory ChallengeSingleton() => _instance ??= ChallengeSingleton._privateConstructor();

//   bool challengeInProgress = false;

//   int counter = 0;

//   void increment() {
//     counter++;
//   }
// }

class LazySingleton {

  LazySingleton._privateConstructor();

  static LazySingleton? _instance;

  static LazySingleton get instance => _instance ??= LazySingleton._privateConstructor();

  bool challengeInProgress = false;

  Challenge? activeChallenge;

  late final User currentUser;

  bool showMap = true;

  bool anotherChallengeInProgress(int challengeId) {
    if (activeChallenge != null && activeChallenge!.id != challengeId) {
      return true;
    } 
    return false;
  }
}
