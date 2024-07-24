import 'package:app_credit_card_scanner/constant/string_const.dart';
import 'package:app_credit_card_scanner/presentation/widgets/text_field.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import '../../model/credit_card.dart';
import '../../provider/credit_card_provider.dart';

class CreditCardForm extends StatefulWidget {
   const CreditCardForm({super.key});


  @override
  CreditCardFormState createState() => CreditCardFormState();
}

class CreditCardFormState extends State<CreditCardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String _selectedCountry = '';
  String _cardType = 'Unknown';
  String _cardHolder = 'CARDHOLDER';
  String _date = DateFormat('MM/yy').format(
      DateTime.now().add(const Duration(days: 365 * 4)));
  late CreditCardProvider provider;


  @override
  void initState() {
    super.initState();
   provider =   Provider.of<CreditCardProvider>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PlainFormTextField(
                controller: _cardNumberController,
                hintText: StringConstants.cardHint,
                keyboardType: TextInputType.number,
                leadingIcon: Icons.credit_card,
                trailingIcon: Icons.check_circle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.formTextErrorMessage;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _cardType = inferCardType(value);
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            PlainFormTextField(
              controller: _cvvController,
              hintText: StringConstants.cvvHint,
              keyboardType: TextInputType.number,
              leadingIcon: Icons.add_card,
              trailingIcon: Icons.check_circle,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringConstants.formTextErrorMessage;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(10),
                      child: Text('${StringConstants.cardType}: $_cardType')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(2),
                    child: TextButton(
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            setState(() {
                              _selectedCountry = country.name;
                            });
                          },
                        );
                      },
                      child: Text(_selectedCountry.isEmpty
                          ? StringConstants.selectCountry
                          : _selectedCountry),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final card = CreditCard(
                        expiryDate: _date,
                        cardHolder : _cardHolder,
                        cardNumber: _cardNumberController.text,
                        cardType: _cardType,
                        cvv: _cvvController.text,
                        issuingCountry: _selectedCountry,
                      );
                      provider.addCreditCard(card);
                      if(provider.submitStatus){
                        _cardNumberController.text = "";
                        _cvvController.text = "";
                      }
                    }
                  },
                  child: const Text(StringConstants.submit),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async {

                    var cardDetails = await CardScanner.scanCard();
                    if(cardDetails != null){
                      _cardNumberController.text = cardDetails.cardNumber;
                      _cvvController.text = cardDetails.cardNumber.substring(0, 3);
                      _cardNumberController.text = cardDetails.cardNumber;
                    }
                    setState(() {
                      _cardType  = cardDetails?.cardIssuer.split('.').last.toUpperCase() ?? _cardType;
                      _cardHolder = (cardDetails?.cardHolderName == null || cardDetails!.cardHolderName.isEmpty) ? _cardHolder : cardDetails.cardHolderName;
                      _date = cardDetails?.expiryDate ?? _date;
                    });
                  },
                  child: const Text(StringConstants.scanCard),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}
