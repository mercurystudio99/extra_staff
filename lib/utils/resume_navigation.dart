import 'dart:convert';
import 'package:extra_staff/views/about_you/address_v.dart';
import 'package:extra_staff/views/about_you/availability_v.dart';
import 'package:extra_staff/views/about_you/bank_details_v.dart';
import 'package:extra_staff/views/about_you/equality_monitoring_v.dart';
import 'package:extra_staff/views/employment/employment_v.dart';
import 'package:extra_staff/views/legal_agreements/agreement1_v.dart';
import 'package:extra_staff/views/legal_agreements/agreements_v.dart';
import 'package:extra_staff/views/legal_agreements/hmrc_checklist_start_v.dart';
import 'package:extra_staff/views/legal_agreements/hmrc_checklist_v.dart';
import 'package:extra_staff/views/legal_agreements/interview_v.dart';
import 'package:extra_staff/views/legal_agreements/user_confirmation_v.dart';
import 'package:extra_staff/views/list_to_upload_v.dart';
import 'package:extra_staff/views/employment/company_details_v.dart';
import 'package:extra_staff/views/employment/employment_history_v.dart';
import 'package:extra_staff/views/legal_agreements/medical_history1_v.dart';
import 'package:extra_staff/views/legal_agreements/medical_history2_v.dart';
import 'package:extra_staff/views/legal_agreements/medical_history3_v.dart';
import 'package:extra_staff/views/onboarding/competency_test_v.dart';
import 'package:extra_staff/views/onboarding/onboarding_wizard_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:extra_staff/views/save_photo_v.dart'
    if (dart.library.html) 'package:extra_staff/views/save_photo_web_v.dart';
import 'package:extra_staff/views/upload_documents_v.dart';
import 'package:extra_staff/views/working_with_us/availability2_v.dart';
import 'package:extra_staff/views/working_with_us/driving_test_v.dart';
import 'package:extra_staff/views/working_with_us/licences_upload_v.dart';
import 'package:extra_staff/views/working_with_us/roles_v.dart';
import 'package:extra_staff/views/working_with_us/skills_v.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/ab.dart';

class Todo {
  String title;
  bool done;

  Todo({required this.title, required this.done});

  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json['title'], done: json['done']);
}

class Resume {
  Resume._privateConstructor();
  static final Resume shared = Resume._privateConstructor();
  List<Todo> allClasses = [];

  int get progress {
    if (allClasses.isEmpty) return 0;
    final completed = allClasses.where((item) => item.done == true).length;
    print('resume_navigation completed');
    print(completed);
    return (completed / allClasses.length * 100).round();
  }

  int getProgressFromScreenId(int screenId){
    return screenId * 100 ~/ 27;
  }

  init() {
    allClasses = [];
  }

  Future getClass() async {
    if (allClasses.isEmpty) {
      final list = localStorage?.getStringList('resume');
      if (list != null && list.isNotEmpty) {
        for (var e in list) {
          allClasses.add(Todo.fromJson(json.decode(e)));
        }
      } else {
        allClasses = [
          // Start screens
          Todo(title: 'ListToUploadView', done: false),
          Todo(title: 'UploadDocumentsView', done: false),
          Todo(title: 'SavePhoto', done: false),
          Todo(title: 'RegistrationView', done: false),
          // About you
          Todo(title: 'Address', done: false),
          Todo(title: 'Availability', done: false),
          Todo(title: 'BankDetails', done: false),
          Todo(title: 'EqualityMonitoring', done: false),
          // Employment history
          Todo(title: 'EmploymentHistory', done: false),
          Todo(title: 'CompanyDetails', done: false),
          Todo(title: 'EmploymentView', done: false),
          // Working with us
          Todo(title: 'RolesView', done: false),
          Todo(title: 'SkillsView', done: false),
          Todo(title: 'LicencesUploadView', done: false),
          Todo(title: 'Availability2', done: false),
          Todo(title: 'DrivingTestView', done: false),
          Todo(title: 'CompetencyTest', done: false),
          Todo(title: 'OnboardingWizard', done: false),
          // Leagal agreements and checklist
          Todo(title: 'HMRCChecklistStartView', done: false),
          Todo(title: 'HMRCChecklistView', done: false),
          Todo(title: 'AgreementsView', done: false),
          Todo(title: 'Agreement1', done: false),
          Todo(title: 'UserConfirmationView', done: false),
          Todo(title: 'Interview', done: false),
          Todo(title: 'MedicalHistory1', done: false),
          Todo(title: 'MedicalHistory2', done: false),
          Todo(title: 'MedicalHistory3', done: false),
        ];

        List<String> list = [];
        for (var e in allClasses) {
          list.add(jsonEncode(e.toJson()));
        }
        await localStorage?.setStringList('resume', list);
      }
    }
  }

  Future setDone({String? name}) async {
    final named = name ?? Get.currentRoute.substring(1);
    final t = allClasses.firstWhere((e) => e.title == named,
        orElse: () => Todo(title: '', done: false));
    t.done = true;
    List<String> list = [];
    for (var e in allClasses) {
      list.add(jsonEncode(e.toJson()));
    }
    await localStorage?.setStringList('resume', list);
  }

  Future markAllDone() async {
    for (var item in allClasses) {
      item.done = true;
    }
  }

  Future markAllNotDone() async {
    for (var item in allClasses) {
      item.done = false;
    }
  }

  navigate() {
    final goTo = allClasses.firstWhere((e) => e.done == false,
        orElse: () => Todo(title: 'RegistrationView', done: false));
    print(goTo.title);
    if (goTo.title == 'RegistrationView') {
      Get.to(() => RegistrationView(), arguments: true);
    } else {
      Get.to(() => ListToUploadView());
    }
  }

  Future completedProgress(int index) async {
    if (index > 0) {
      allClasses.sublist(0, index).forEach((element) {
        element.done = true;
      });
      if (index != 27) allClasses[3].done = false;
      List<String> sections = [];
      if (index >= 8) sections.add('isAboutYouCompleted');
      if (index >= 11) sections.add('isEmploymentHistoryCompleted');
      if (index >= 17) sections.add('isCompetencyTestCompleted');
      if (index >= 20) sections.add('isHMRCCompleted');
      if (index >= 27) sections.add('isAgreementsCompleted');
      for (final element in sections) {
        await localStorage?.setBool(element, true);
      }

      List<String> list = [];
      for (var e in allClasses) {
        list.add(jsonEncode(e.toJson()));
      }
      await localStorage?.setStringList('resume', list);
    }
  }
}
