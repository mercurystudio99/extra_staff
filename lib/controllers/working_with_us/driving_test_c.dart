import 'package:extra_staff/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/driving_test_m.dart';
import 'package:extra_staff/models/key_value_m.dart';

class DrivingTestController extends GetxController {
  final drivingTest = GlobalKey<FormState>();

  DrivingTestModel test = DrivingTestModel.fromJson({});

  String licenseDateApp = '';

  final selectData = [
    KeyValue('', '-'),
    KeyValue('9', '9'),
    KeyValue('9', '9'),
    KeyValue('4.5', '4.5'),
    KeyValue('15', '15'),
    KeyValue('56', '56'),
    KeyValue('11', '11'),
    KeyValue('15', '15'),
    KeyValue('30', '30'),
    KeyValue('2', '2'),
    KeyValue('45', '45'),
    KeyValue('10', '10'),
    KeyValue('45', '45'),
    KeyValue('90', '90'),
    KeyValue('24', '24'),
    KeyValue('48', '48'),
    KeyValue('6', '6'),
    KeyValue('35', '35'),
    KeyValue('30', '30'),
    KeyValue('45', '45'),
    KeyValue('60', '60'),
  ];

  KeyValue selected_maxDriHours = KeyValue.fromJson({});
  KeyValue selected_breakMinutes = KeyValue.fromJson({});
  KeyValue selected_repBreakMinutes = KeyValue.fromJson({});
  KeyValue selected_folBreakMinutes = KeyValue.fromJson({});
  KeyValue selected_dayHours = KeyValue.fromJson({});
  KeyValue selected_weekOcca = KeyValue.fromJson({});
  KeyValue selected_maxHour = KeyValue.fromJson({});
  KeyValue selected_weekMaxHour = KeyValue.fromJson({});
  KeyValue selected_exceedHour = KeyValue.fromJson({});
  KeyValue selected_dayMinHours = KeyValue.fromJson({});
  KeyValue selected_dayRestMinHours = KeyValue.fromJson({});
  KeyValue selected_weekRestHour = KeyValue.fromJson({});
  KeyValue selected_weekRedRestHour = KeyValue.fromJson({});
  KeyValue selected_trainingHours = KeyValue.fromJson({});
  KeyValue selected_maxHourLim = KeyValue.fromJson({});
  KeyValue selected_minBreakMinutes = KeyValue.fromJson({});
  KeyValue selected_totalBreakMin = KeyValue.fromJson({});
  KeyValue selected_breakMin = KeyValue.fromJson({});
  KeyValue selected_totalHours = KeyValue.fromJson({});
  KeyValue selected_weekMaxHourLim = KeyValue.fromJson({});

  final row1 = [
    '9',
    '9',
    '4.5',
    '15',
    '56',
    '11',
    '15',
    '30',
    '2',
    '45',
  ];

  final row2 = [
    '10',
    '45',
    '90',
    '24',
    '48',
    '6',
    '35',
    '30',
    '45',
    '60',
  ];

  final longTexts = [
    "The numbers needed to complete the following statements in the driver's hours and working time test are all tabled below.",
    'You can drive for a maximum of ＿ hours before you are required to take a break from driving.',
    'When the maximum driving period before a break is required is reached, a break of ＿ minutes must be taken or commence period of rest.',
    'This break may be replaced by a break of at least ＿ minutes followed by a break of at least ＿ minutes providing the driver does not exceed maximum driving time without a break.',
    'You are permitted to drive up to ＿ hours per day normally.',
    'The driver can extend the driving period on no more than ＿ occasions in a week, to a maximum of ＿ hours.',
    'Maximum number of hours that can be driven in a week is ＿ hours but the driver must not exceed ＿ hours in two consecutive weeks.',
    'Break is defined as any period during which the driver may NOT carry out any driving or any other work and which is used exclusively for recuperation',
    'Rest is defined as a period during which the driver may freely dispose of their time. All daily rest must be completed within the 24 hour period which commenced when the driver started duty',
    'A regular daily rest is deemed to be a period of at least ＿ hours.',
    'A reduced daily rest is at least ＿ hours.',
    'In any two consecutive weeks a driver shall take at least:',
    'Two regular rest periods or',
    'One regular weekly rest period and one reduced weekly rest period of at least 24 hours. However, the reduction shall be compensated by an equivalent period of rest taken en bloc before the end of the third week following the week in question and attached to another period of rest of at least 9 hours.',
    'A regular weekly rest is at least ＿ hours and a reduced weekly rest is a minimum of ＿ hours.',
    'A driver is required to complete ＿ hours periodic training every 5 years to obtain a drivers CPC.',
    'Working Time',
    "All drivers of vehicles that are subject to the EC driver's hours rules have to apply the Working Time Regs.",
    "Working Time does not include 'periods of availability' or 'breaks' but does include driving and all other duties",
    'Breaks taken to comply with working time can also satisfy all or part of your requirements to take a break from driving.',
    'A driver must not exceed ＿ hours work without taking a break',
    'The minimum break period is ＿ minutes',
    'A shift of between 6 & 9 hours will require breaks totalling ＿ minutes to be taken.',
    'A shift of over 9 hours will require breaks totalling ＿ minutes to be taken.',
    'The average working time over the reference period must not exceed ＿ hours.',
    'The maximum time that can he worked in any one week is ＿ hours.',
  ];

  bool validate() {
    drivingTest.currentState!.validate();
    return true;
  }

  bool validated() {
    if (test.licenseDate.isEmpty) {
      abShowMessage('Please enter Licence date.');
    } else if (drivingTest.currentState!.validate()) {
      return true;
    } else {
      abShowMessage('error'.tr);
    }
    return false;
  }

  Future<bool> getTempDrivingTestInfo() async {
    selected_maxDriHours = selectData.first;
    selected_breakMinutes = selectData.first;
    selected_repBreakMinutes = selectData.first;
    selected_folBreakMinutes = selectData.first;
    selected_dayHours = selectData.first;
    selected_weekOcca = selectData.first;
    selected_maxHour = selectData.first;
    selected_weekMaxHour = selectData.first;
    selected_exceedHour = selectData.first;
    selected_dayMinHours = selectData.first;
    selected_dayRestMinHours = selectData.first;
    selected_weekRestHour = selectData.first;
    selected_weekRedRestHour = selectData.first;
    selected_trainingHours = selectData.first;
    selected_maxHourLim = selectData.first;
    selected_minBreakMinutes = selectData.first;
    selected_totalBreakMin = selectData.first;
    selected_breakMin = selectData.first;
    selected_totalHours = selectData.first;
    selected_weekMaxHourLim = selectData.first;

    final response = await Services.shared.getTempDrivingTestInfo();
    if (response.errorMessage.isNotEmpty) {
      abShowMessage(response.errorMessage);
      return false;
    }

    test.driverName = userName;

    if (response.errorCode == 0 && response.result is Map) {
      test = DrivingTestModel.fromJson(response.result);
      if (test.licenseDate.isNotEmpty) {
        final date = stringToDate(test.licenseDate, true);
        licenseDateApp =
            date != null ? formatDate(date) : dateToString(getNow, false) ?? '';
      }

      if (test.maxDriHours.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.maxDriHours);
        selected_maxDriHours = selectData[index];
      }
      if (test.breakMinutes.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.breakMinutes);
        selected_breakMinutes = selectData[index];
      }
      if (test.repBreakMinutes.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.repBreakMinutes);
        selected_repBreakMinutes = selectData[index];
      }
      if (test.folBreakMinutes.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.folBreakMinutes);
        selected_folBreakMinutes = selectData[index];
      }
      if (test.dayHours.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.dayHours);
        selected_dayHours = selectData[index];
      }
      if (test.weekOcca.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.weekOcca);
        selected_weekOcca = selectData[index];
      }
      if (test.maxHour.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.maxHour);
        selected_maxHour = selectData[index];
      }
      if (test.weekMaxHour.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.weekMaxHour);
        selected_weekMaxHour = selectData[index];
      }
      if (test.exceedHour.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.exceedHour);
        selected_exceedHour = selectData[index];
      }
      if (test.dayMinHours.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.dayMinHours);
        selected_dayMinHours = selectData[index];
      }
      if (test.dayRestMinHours.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.dayRestMinHours);
        selected_dayRestMinHours = selectData[index];
      }
      if (test.weekRestHour.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.weekRestHour);
        selected_weekRestHour = selectData[index];
      }
      if (test.weekRedRestHour.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.weekRedRestHour);
        selected_weekRedRestHour = selectData[index];
      }
      if (test.trainingHours.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.trainingHours);
        selected_trainingHours = selectData[index];
      }
      if (test.maxHourLim.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.maxHourLim);
        selected_maxHourLim = selectData[index];
      }
      if (test.minBreakMinutes.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.minBreakMinutes);
        selected_minBreakMinutes = selectData[index];
      }
      if (test.totalBreakMin.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.totalBreakMin);
        selected_totalBreakMin = selectData[index];
      }
      if (test.breakMin.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.breakMin);
        selected_breakMin = selectData[index];
      }
      if (test.totalHours.isNotEmpty) {
        final index =
            selectData.indexWhere((element) => element.id == test.totalHours);
        selected_totalHours = selectData[index];
      }
      if (test.weekMaxHourLim.isNotEmpty) {
        final index = selectData
            .indexWhere((element) => element.id == test.weekMaxHourLim);
        selected_weekMaxHourLim = selectData[index];
      }
    }
    return true;
  }

  Future<bool> updateTempDrivingTestInfo() async {
    print(test.driverName);
    final response = await Services.shared.updateTempDrivingTestInfo(test);
    if (response.errorMessage.isEmpty) {
      return true;
    } else {
      abShowMessage(response.errorMessage);
      return false;
    }
  }
}
