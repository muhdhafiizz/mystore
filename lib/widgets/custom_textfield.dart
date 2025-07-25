import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mystore_assessment/providers/login_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return TextField(
      controller: controller,
      obscureText: isPassword ? loginProvider.obscurePassword : false,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.black),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  loginProvider.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: loginProvider.togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}
