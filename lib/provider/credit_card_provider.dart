import 'package:app_credit_card_scanner/constant/string_const.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/credit_card.dart';

class CreditCardProvider with ChangeNotifier {
  List<CreditCard> _creditCards = [];
  final List<String> _bannedCountries = ["Afghanistan", "Angola", "Australia", "Belgium"];
  late CardDetails _currentCard;
  String _errorMessage = "";
  bool _submitStatus = false;

  List<CreditCard> get creditCards => _creditCards;
  List<String> get bannedCountries => _bannedCountries;
  CardDetails get currentCard => _currentCard;
  String get errorMessage => _errorMessage;
  bool get submitStatus => _submitStatus;


  void addCreditCard(CreditCard card) {
    if (card.cardNumber.length < 8 || card.cardNumber.length > 19) {
      _errorMessage = StringConstants.cardNumberErrorMessage;
      _submitStatus = false;
      notifyListeners();
      return;
    }
    if (card.cvv.length > 5) {
      _errorMessage = StringConstants.cvvLengthErrorMessage;
      _submitStatus = false;
      notifyListeners();
      return;
    }
    if (_bannedCountries.contains(card.issuingCountry)) {
      _errorMessage = StringConstants.bannedCountriesErrorMessage;
      _submitStatus = false;
      notifyListeners();
      return;
    }
    if (_creditCards.any((c) => c.cardNumber == card.cardNumber)) {
      _errorMessage = StringConstants.cardAddedErrorMessage;
      _submitStatus = false;
      notifyListeners();
      return;
    }
    _creditCards.add(card);
    _errorMessage = "";
    notifyListeners();
    _saveCardsToLocal();
    _submitStatus = true;
  }

  void loadCardsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardStrings = prefs.getStringList(StringConstants.localSharedPrefString);
    if (cardStrings != null) {
      _creditCards = cardStrings.map((cardString) => CreditCard.fromJson(jsonDecode(cardString))).toList();
      notifyListeners();
    }
  }

  CreditCardProvider() {
    loadCardsFromLocal();
  }

  void _saveCardsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardStrings = _creditCards.map((card) => jsonEncode(card.toJson())).toList();
    await prefs.setStringList(StringConstants.localSharedPrefString, cardStrings);
  }
}

String inferCardType(String cardNumber) {
  cardNumber = cardNumber.replaceAll(' ', '');

  if (RegExp(r'^3[47][0-9]{13}$').hasMatch(cardNumber)) {
    return 'Amex';
  } else if (RegExp(r'^(6541|6556)[0-9]{12}$').hasMatch(cardNumber)) {
    return 'BCGlobal';
  } else if (RegExp(r'^389[0-9]{11}$').hasMatch(cardNumber)) {
    return 'Carte Blanche';
  } else if (RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$').hasMatch(cardNumber)) {
    return 'Diners Club';
  } else if (RegExp(r'^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9]{2}|9[01][0-9]|92[0-5])[0-9]{10})$').hasMatch(cardNumber)) {
    return 'Discover';
  } else if (RegExp(r'^63[7-9][0-9]{13}$').hasMatch(cardNumber)) {
    return 'Insta Payment';
  } else if (RegExp(r'^(?:2131|1800|35\d{3})\d{11}$').hasMatch(cardNumber)) {
    return 'JCB';
  } else if (RegExp(r'^9[0-9]{15}$').hasMatch(cardNumber)) {
    return 'KoreanLocalCard';
  } else if (RegExp(r'^(6304|6706|6709|6771)[0-9]{12,15}$').hasMatch(cardNumber)) {
    return 'Laser';
  } else if (RegExp(r'^(5018|5020|5038|6304|6759|6761|6763)[0-9]{8,15}$').hasMatch(cardNumber)) {
    return 'Maestro';
  } else if (RegExp(r'^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$').hasMatch(cardNumber)) {
    return 'MasterCard';
  } else if (RegExp(r'^(6334|6767)[0-9]{12}|(6334|6767)[0-9]{14}|(6334|6767)[0-9]{15}$').hasMatch(cardNumber)) {
    return 'Solo';
  } else if (RegExp(r'^(4903|4905|4911|4936|6333|6759)[0-9]{12}|(4903|4905|4911|4936|6333|6759)[0-9]{14}|(4903|4905|4911|4936|6333|6759)[0-9]{15}|564182[0-9]{10}|564182[0-9]{12}|564182[0-9]{13}|633110[0-9]{10}|633110[0-9]{12}|633110[0-9]{13}$').hasMatch(cardNumber)) {
    return 'Switch';
  } else if (RegExp(r'^(62[0-9]{14,17})$').hasMatch(cardNumber)) {
    return 'Union Pay';
  } else if (RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$').hasMatch(cardNumber)) {
    return 'Visa';
  } else if (RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})$').hasMatch(cardNumber)) {
    return 'Visa MasterCard';
  }
  return 'Unknown';
}
