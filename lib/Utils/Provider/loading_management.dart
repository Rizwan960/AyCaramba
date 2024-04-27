import 'package:flutter/material.dart';

class LoadingManagemet extends ChangeNotifier {
  bool _isApiHitting = false;
  bool get isApiHitting => _isApiHitting;

  void changeApiHittingBehaviourToTrue() {
    _isApiHitting = true;
    notifyListeners();
  }

  void changeApiHittingBehaviourToFalse() {
    _isApiHitting = false;
    notifyListeners();
  }
}
