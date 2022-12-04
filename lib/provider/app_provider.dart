import 'package:flutter/material.dart';

enum Language { francais, dioula, baoule }

enum Turn { on, off }

enum Option { posologie, medicament }

class AppProvider extends ChangeNotifier {
  Language _language = Language.francais;
  Turn _turn = Turn.off;
  Option _option = Option.posologie;

  Language get language => _language;
  Turn get turn => _turn;
  Option get option => _option;

  void setLanguage(Language language) {
    _language = language;
    notifyListeners();
  }

  void setTurn(Turn turn) {
    _turn = turn;
    notifyListeners();
  }

  void setOption(Option option) {
    _option = option;
    notifyListeners();
  }
}
