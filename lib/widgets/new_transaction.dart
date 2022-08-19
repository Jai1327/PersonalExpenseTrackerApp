import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  late final Function _addTransaction;

  NewTransaction(this._addTransaction) {
    print("Constructor() NewTransactions");
  }

  @override
  State<NewTransaction> createState() {
    print("CreateState() NewTransactions");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  late String _titleInput;

  final _amtInput = TextEditingController();

  _NewTransactionState() {
    print("Constructor() NewTransactionState");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState() NewTransactionState");
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    /*here we can get access to the new widget and it takes the old  widget
    as a parameter, therefore, it can be used to compare */
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget() NewTransactionState");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Dispose() NewTransactionState ");
  }

  DateTime? _selectedDate;

  void _submitData() {
    if (_amtInput.text.isEmpty) {
      return;
    }
    // in order to stop this from running before all is submitted
    final enteredTitle = _titleInput;
    final enteredAmt = double.parse(_amtInput.text);

    //check
    if (enteredTitle.isEmpty || enteredAmt <= 0 || _selectedDate == null) {
      return;
    }

    print(_titleInput + " " + _amtInput.text);
    widget._addTransaction(enteredTitle, enteredAmt, _selectedDate);
    // above is the method used to access a function in a widget from its state class

    // inorder to closed the bottomModalSheet once a transaction is added
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (String val) {
              //   amtInput = val;
              // },
              // in place of onChanged, used controller
              controller: _amtInput,
              keyboardType: TextInputType
                  .number, // this is used to change keyboard to numbers
              onSubmitted: (_) =>
                  _submitData(), // this is another way of writing
            ),
            TextField(
              decoration: InputDecoration(labelText: 'note'),
              onChanged: (String val) {
                _titleInput = val;
              },
              onSubmitted: (val) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date choosen!'
                          : DateFormat.yMd().format(_selectedDate!),
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      "Choose date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: _submitData,
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text(
                "Add",
                style: TextStyle(fontSize: 16),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
