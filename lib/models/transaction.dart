class Transaction {
  /* This class will be a blueprint for a normal dart object */
  final String id;
  final String title;
  final double amount;
  final DateTime date; //built into dart
  // above mentioned are the properties that make up a transaction
  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}
