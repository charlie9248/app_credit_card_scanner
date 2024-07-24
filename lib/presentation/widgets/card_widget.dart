import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../constant/string_const.dart';
import 'bodyText.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final String cvv;
  final Color cardColor;
  final List<Color> gradientColors;


  const CreditCardWidget({super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.cvv,
    required this.gradientColors,
    this.cardColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: gradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                child: Image.asset(
                  'assets/chip.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              BodyText(
                text: cardType,
                style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Spacer(),
          Text(
            cardNumber,
            style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),

           BodyText(
           text:  "cvc $cvv",
            style: const TextStyle(color: AppColors.white, fontSize: 16,),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BodyText(
                    text: StringConstants.cardHolder,
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                  ),
                   BodyText(
                    text :cardHolderName,
                    style:  const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BodyText(
                    text: StringConstants.validThru,
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                  ),
                  BodyText(
                    text: expiryDate,
                    style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}