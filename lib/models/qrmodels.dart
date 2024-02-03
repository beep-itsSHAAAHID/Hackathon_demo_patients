import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppointmentQrDataModel {
  late String doctorName;
  late String patientName;
  late String token;

  AppointmentQrDataModel({
    required this.doctorName,
    required this.patientName,
    required this.token,
  });

  List<int> toBytes() {
    BytesBuilder bytesBuilder = BytesBuilder();

    _addTLV(bytesBuilder, 1, utf8.encode(doctorName));

    _addTLV(bytesBuilder, 2, utf8.encode(patientName));

    _addTLV(bytesBuilder, 3, utf8.encode(token));

    return bytesBuilder.toBytes();
  }

  void _addTLV(BytesBuilder bytesBuilder, int tag, List<int> value) {
    bytesBuilder.addByte(tag);
    bytesBuilder.addByte(value.length);
    bytesBuilder.add(value);
  }

  String generateBookingQrBase64Code() {
    Uint8List bytes = Uint8List.fromList(toBytes());
    String qrCodeBase64 = base64.encode(bytes);
    return qrCodeBase64;
  }

  Widget generateQrCodeWidget() {
    String qrCode = generateBookingQrBase64Code();
    return QrImageView(data: qrCode, version: QrVersions.auto, size: 200.0);
  }

  Uint8List hexStringToBytes(String hexString) {
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String hex = hexString.substring(i, i + 2);
      bytes.add(int.parse(hex, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}

class AppointmentQrController {
  AppointmentQrController._();

  static String generateBookingQrBase64Code(
      AppointmentQrDataModel AppointmentData) {
    Uint8List bytes = Uint8List.fromList(AppointmentData.toBytes());
    String qrCodeBase64 = base64.encode(bytes);
    return qrCodeBase64;
  }
}