import 'dart:html';
import 'package:extra_staff/utils/services.dart';

void initBaseUrl() {
  String url = window.location.href;
  if (url == "https://temp.extrastaff.com/") {
    Services.shared.baseApiUrl = "https://services.extrastaff.com/";
  } else {
    Services.shared.baseApiUrl = "https://development.services.extrastaff.com/";
  }
  print(url);
}
