import 'package:flutter/material.dart';
import 'package:mystore_assessment/providers/login_provider.dart';
import 'package:mystore_assessment/ui/home_view.dart';
import 'package:mystore_assessment/widgets/custom_button.dart';
import 'package:mystore_assessment/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<LoginProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  _buildLogo(),
                  _buildLoginText(),
                  SizedBox(height: 20),
                  _buildUsernameTextfield(usernameController, "Username"),
                  const SizedBox(height: 10),
                  _buildPasswordTextfield(passwordController, "Password"),
                  SizedBox(height: 20,),
                  if (provider.error != null)
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  Spacer(),
                  _buildLoginButton(
                    context,
                    usernameController,
                    passwordController,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildLogo() {
  return Image.asset("assets/logo/mystore_logo.png", height: 100, width: 100);
}

Widget _buildLoginText() {
  return Text(
    "Login to shop",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );
}

Widget _buildUsernameTextfield(TextEditingController controller, String label) {
  return CustomTextField(
    controller: controller,
    label: label,
  );
}

Widget _buildPasswordTextfield(TextEditingController controller, String label) {
  return CustomTextField(
    controller: controller,
    label: label,
    obscureText: true,
  );
}

Widget _buildLoginButton(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController passwordController,
) {
  final provider = Provider.of<LoginProvider>(context, listen: false);

  return CustomButton(
    text: "Log in",
    backgroundColor: Colors.green,
    textColor: Colors.white,
    onTap: () async {
      provider.showLoadingDialog(context);

      final success = await provider.login(
        usernameController.text,
        passwordController.text,
      );

      if (context.mounted) Navigator.pop(context);

      if (success && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    },
  );
}
