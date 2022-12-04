// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ar/utils/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

Future<String> goodValue(String medoc) async {
  String url = 'https://www.doctissimo.fr/medicament-$medoc.htm';
  final response = await http.get(Uri.parse(url));
  final body = response.body;
  final html = parse(body);

  final indication = html.querySelector("#main-container")?.text.trim();
   logger.d(indication);
  if (indication != null) {
    return medoc;
  }

  return "null";
}

void main() {
  test('traduction', () async {
    String resp = await goodValue("paracetamol");
    logger.d(resp);
  });
}
