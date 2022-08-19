import 'package:expense/models/transaction.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart'; // to formate date
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;
  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(children: [
              Text('No Transactions Added',
                  // style: TextStyle(color: Colors.grey),
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.contain,
                  ))
            ]); // render the image ;
          })
        : ListView(
            children: transactions
                .map((e) => transactionItem(
                    key: ValueKey(e.id),
                    transaction: e,
                    deleteTransaction: _deleteTransaction))
                .toList());
    // ListView.builder(
    //     itemBuilder: (ctx, index) {
    //       return transactionItem(
    //           transaction: transactions[index],
    //           deleteTransaction: _deleteTransaction);
    //     },
    //     itemCount: transactions.length,
    //     //itemBuilder takes a function
    //   );
  }
}
