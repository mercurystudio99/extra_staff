import 'package:extra_staff/utils/ab.dart';

class SignatureData {
  String id;
  String signature;

  SignatureData({
    required this.id,
    required this.signature,
  });

  factory SignatureData.fromJson(Map<String, dynamic> json) {
    return SignatureData(
      id: ab(json['id'], fallback: ''),
      signature: ab(json['signature'], fallback: ''),
    );
  }
}
