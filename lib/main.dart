import 'package:app_credit_card_scanner/constant/string_const.dart';
import 'package:app_credit_card_scanner/presentation/views/card_list.dart';
import 'package:app_credit_card_scanner/presentation/widgets/form_widget.dart';
import 'package:app_credit_card_scanner/provider/credit_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreditCardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text(StringConstants.title)),
          body: Consumer<CreditCardProvider>(
            builder: (context, provider, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (provider.errorMessage.isNotEmpty) {
                  showCustomSnackBar(context, provider.errorMessage);
                }
              });
              return const Column(
                children:  [
                  CreditCardForm(),
                  Expanded(child: CapturedCardsList()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
