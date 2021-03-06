import 'package:expenses_app/Components/transaction_list.dart';
import 'package:expenses_app/components/transaction_form.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import 'dart:math';
import 'dart:io';

import 'components/chart.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData.dark(
          // primarySwatch: Colors.amber,
          // accentColor: Colors.grey[700],
          // fontFamily: 'Quicksand',
          // textTheme: ThemeData.light().textTheme.copyWith(
          //       headline6: TextStyle(
          //         fontFamily: 'OpenSans',
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          // appBarTheme: AppBarTheme(
          //   textTheme: ThemeData.light().textTheme.copyWith(
          //         headline6: TextStyle(
          //           fontFamily: 'OpenSans',
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          // ),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [];

  void _addTransaction(String title, double value, DateTime date) {
    Transaction newTransaction = new Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      transactions.add(newTransaction);
    });

    //Fecha o modal após o submit e a criação da transação
    Navigator.of(context).pop();
  }

  //Exibe o Modal
  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TransactionForm(_addTransaction),
    );
  }

  //Pega apenas as transações realizadas nos ultimos 7 dias.
  List<Transaction> get _recentTransaction {
    return transactions
        .where(
            (t) => t.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _deleteTransation(String id) {
    setState(() {
      transactions.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.amber,
      title: Text(
        'Despesas pessoais',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () => _openTransactionFormModal(context),
        )
      ],
    );

    final availableHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: availableHeight * 0.25,
              child: Chart(_recentTransaction),
            ),
            Container(
              height: availableHeight * 0.75,
              child: TransactionList(transactions, _deleteTransation),
            ),
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.amber,
              elevation: 5,
              onPressed: () => _openTransactionFormModal(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
