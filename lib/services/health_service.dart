

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthService {

  final health = Health();

  static const dataTypes = [
    HealthDataType.STEPS,
  ];

  static const permissions = [HealthDataAccess.READ];

  int _currentSteps = 0;

  int get currentSteps => _currentSteps;

  Future<void> installHealthConnect() async => await health.installHealthConnect();

  Future<int> fetchStepData() async {

    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    await getHealthConnectSdkStatus();

    health.installHealthConnect();

    bool stepsPermission =
        await health.hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
        await health.requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      debugPrint('Total number of steps: $steps');

      _currentSteps = steps ?? 0;

    } else {
      debugPrint("Authorization not granted - error in authorization");
    }

    return steps ?? 0;
  }

  Future<void> getHealthConnectSdkStatus() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await health.getHealthConnectSdkStatus();

    print(status);
  }

  Future<bool> revokeAccess() async {

    bool success = false;

    try {
      await health.revokePermissions();
      success = true;
    } catch (error) {
      debugPrint("Exception in revokeAccess: $error");
    }
      return success;
  }

}