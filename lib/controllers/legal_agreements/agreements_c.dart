import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/signature_data_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class AgreementsController extends GetxController {
  String txt = '';
  int currentIndex = 1;
  List<String> status = [];
  String signatureBlob = '';
  final allAgreements = [
    KeyValue('1', 'Extrastaff Pension'),
    KeyValue('2', 'Now Pension'),
    KeyValue('3', 'GDPR / Privacy Statement'),
    KeyValue('4', 'Code of Conduct'),
    KeyValue('5', 'Manual Handling'),
    KeyValue('6', 'Terms of Engagement'),
  ];

  nextAgreement() async {
    if (currentIndex < allAgreements.length) {
      currentIndex += 1;
    }
  }

  bool allAccepted() {
    status = [
      ...{...status}
    ];
    print(status.length);

    if(status.contains('1') && status.contains('2') && status.contains('3') && status.contains('4') && status.contains('5')){
      return true;
    }
    else
      return false;
  }

  Future<String> getTempSignatureInfo() async {
    final response = await Services.shared.getTempSignatureInfo();
    if (response.result is Map) {
      SignatureData data = SignatureData.fromJson(response.result);
      var index = data.signature.indexOf("base64,");
      if (index > 0)
        signatureBlob = data.signature.substring(index + 7);
      else
        signatureBlob = data.signature;
    }
    return response.errorMessage;
  }

  Future<String> updateTempAgreementInfo() async {
    final response =
        await Services.shared.updateTempAgreementInfo('$currentIndex');
    return response.errorMessage;
  }

  Future<String> getTempAgreementInfo() async {
    final response = await Services.shared.getTempAgreementInfo();
    if (response.result is List) {
      status = [];
      for (var i in response.result) {
        if (i is Map) {
          if (i['document_type'] is String) {
            status.add(i['document_type']);
          }
        }
      }
    }
    return response.errorMessage;
  }

  Future<String> getAgreementInfo() async {
    final response = await Services.shared.getAgreementInfo('$currentIndex');
    if (response.result is Map) {
      if (response.result['document_type'] is String) {
        txt = response.result['document_type'];
      }
    }
    return response.errorMessage;
  }

  Future<String> putSignature(XFile img) async {
    try {
      final binaryData = await img.readAsBytes();
      String signatureBlob = Base64Codec().encode(binaryData);
      final response = await Services.shared.putSignature(signatureBlob);
      if (response.errorCode == 0) {
        return 'OK';
      } else {
        return response.errorMessage;
      }
    } catch (e) {
      print(e.toString());
      return 'error'.tr;
    }
  }
}
