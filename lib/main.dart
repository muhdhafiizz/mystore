import 'package:flutter/material.dart';
import 'package:mystore_assessment/providers/home_provider.dart';
import 'package:mystore_assessment/providers/login_provider.dart';
import 'package:mystore_assessment/ui/login_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Liter', scaffoldBackgroundColor: Colors.white),
      home: LoginView(),
    );
  }
}
