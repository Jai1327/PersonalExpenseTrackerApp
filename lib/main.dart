import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
// import 'widgets/user_transactions.txt';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // //this line is added in the recent versions of flutter
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // // the above syntax is used to lock the application mode in portrait mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.purple,
        // errorColor: Colors.amber,
        accentColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
            // button: TextStyle(color: Colors.white),

            titleMedium: TextStyle(
                // isme doubt
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        // fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: TextStyle(
                    // isme doubt
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      ),
      //allows to set a global, application wide theme
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String note, double amt, DateTime trxDate) {
    // i++;
    // var id = 't' + i.toString();
    final newTX = new Transaction(
        id: DateTime.now().toString(), title: note, amount: amt, date: trxDate);

    setState(() {
      _transactions.add(newTX);
    });
  }

  void _deleteTransaction(String delID) {
    setState(() {
      _transactions.removeWhere((element) {
        return element.id == delID;
      });
    });
  }

  /* creating a function for the appbar button 
  and the floating button to bring up the bottom 
  modal sheet */
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            // this is used to avoid the sheet to close
            // when tapped onto it, both the above lines
            child: NewTransaction(_addTransaction),
          );
        });
    // bCtx ek jagha _ will also work
  }

  // the builder function
  // builder returns a widget
  List<Widget> _builderLandcapeContent(AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Show Chart"),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          //below it the input area
          : txListWidget
    ];
  }

  List<Widget> _builderNotLandscapeContent(AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

// this is added to add the listner
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    // here we can react to changes in the lifecycle
    print(state);
  }

// this is added to remove the listner
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    // the above line is added to dispose the listnes of LifecycleState
    super.dispose();
    print("Dispose() main.dart");
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
        // style: Theme.of(context).textTheme.titleLarge,
        // doing this for all the appbar on multiple pages is tedious,
        //therefore a theme can be decided
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            1,
        child: TransactionList(_transactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape) ..._builderLandcapeContent(appBar, txListWidget),
              if (!isLandscape)
                // these 3 dots is the spread operator
                ..._builderNotLandscapeContent(appBar, txListWidget),
              // if (!isLandscape) ,
              // if (isLandscape)
            ],
          ),
        ),
      ),
      //changing the location of the floatingactionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: Icon(Icons.add),
            ),
    );
  }
}
