import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class transactionItem extends StatefulWidget {
  const transactionItem({
    Key? key,
    required this.transaction,
    required Function deleteTransaction,
  })  : _deleteTransaction = deleteTransaction,
        super(key: key);

  final transaction;
  final Function _deleteTransaction;

  @override
  State<transactionItem> createState() => _transactionItemState();
}

class _transactionItemState extends State<transactionItem> {
  late Color _bgColor;

  @override
  void initState() {
    // TODO: implement initState
    const availableColor = [
      Colors.purple,
      Colors.brown,
      Colors.amber,
      Colors.blue
    ];

    _bgColor = availableColor[Random().nextInt(4)];
    //Random().nextInt(4) will generate either 0,1,2,3

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(child: Text("Rs.${widget.transaction.amount}")),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () =>
                    widget._deleteTransaction(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text("Delete"),
                textColor: Theme.of(context).errorColor)
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    widget._deleteTransaction(widget.transaction.id),
                // this way, as the normal onpressed does not set an attribute
              ),
      ),
    );
  }
}
