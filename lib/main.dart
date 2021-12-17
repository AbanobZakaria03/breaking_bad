import 'package:flutter/material.dart';
import 'package:flutter_breaking/app_router.dart';

void main() {
  runApp(const BreakingBadApp());
}

class BreakingBadApp extends StatelessWidget {
  const BreakingBadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}