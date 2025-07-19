import 'package:flutter/material.dart';
import 'package:mystore_assessment/services/login_service.dart';
import 'package:mystore_assessment/widgets/custom_loading.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get user => _user;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _loginService.login(username, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (_) => const LoadingDialog(),
    );
  }
}
