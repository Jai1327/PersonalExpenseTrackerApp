import 'package:expense/models/transaction.dart';
import 'package:expense/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  // chart will need our list of transactions
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      double amt = 0;
      final weekDay = DateTime.now().subtract(Duration(days: index));
      // we substract from DateTime.now inorder to
      // get the last entire week,

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          amt += recentTransactions[i].amount;
        }
      }
      // print(DateFormat.E().format(weekDay));
      // print(amt);

      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': amt
      };
      // .E directly gives us three character of weekDay
      // using the substring method to get the 1st character.
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0, (sum, element) {
      return sum + double.parse(element['amount'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactions);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['Day'].toString(),
                  spending: (data['amount'] as double),
                  spendingPercent: totalSpending == 0
                      ? 0
                      : (data['amount'] as double) / totalSpending),
            );
            // error was due to the fact that there might be 0 in place of total spending
          }).toList(),
        ),
      ), // there will be exactly 7 children
    );
  }
}
