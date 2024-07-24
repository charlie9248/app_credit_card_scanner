class CreditCard {
  final String cardNumber;
  final String cardType;
  final String cvv;
  final String issuingCountry;
  final String cardHolder;
  final String expiryDate;

  CreditCard({required this.cardNumber, required this.cardType, required this.cvv, required this.issuingCountry , required this.cardHolder , required this.expiryDate});

  Map<String, dynamic> toJson() => {
    'cardNumber': cardNumber,
    'cardType': cardType,
    'cvv': cvv,
    'issuingCountry': issuingCountry,
    'cardHolderName' : cardHolder,
    'expiryDate' : expiryDate,
  };

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      cvv: json['cvv'],
      issuingCountry: json['issuingCountry'],
      cardHolder : json['cardHolderName'],
      expiryDate : json['expiryDate'],
    );
  }
}