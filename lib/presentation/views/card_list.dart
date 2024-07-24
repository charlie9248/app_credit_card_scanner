import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/credit_card_provider.dart';
import '../widgets/card_widget.dart';

class CapturedCardsList extends StatelessWidget {
  const CapturedCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreditCardProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.creditCards.length,
          itemBuilder: (context, index) {
            final card = provider.creditCards[index];
            return CreditCardWidget(
              gradientColors: generateRandomDarkColors(),
              cvv: card.cvv,
              cardNumber: card.cardNumber,
              expiryDate: card.expiryDate,
              cardHolderName: card.cardHolder,
              cardType: card.cardType,
            );
          },
        );
      },
    );
  }

  List<Color> generateRandomDarkColors() {
    final random = Random();
    Color getRandomDarkColor() {
      int r = random.nextInt(156); // Darker shades of colors
      int g = random.nextInt(156);
      int b = random.nextInt(156);
      return Color.fromARGB(255, r, g, b);
    }

    return [getRandomDarkColor(), getRandomDarkColor()];
  }
}
