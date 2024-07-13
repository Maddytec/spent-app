import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spent/components/transaction_form.dart';
import 'package:spent/components/transaction_list.dart';
import 'package:spent/models/transaction.dart';

main() => runApp(SpentApp());

class SpentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    final primary = Colors.blueAccent[700];
    final secondary = Colors.blue[300];
    final inversePrimary = Colors.blue[50];
    final errorPrimary = Colors.indigo[900];

    return MaterialApp(
      home: MyHomePage(),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: primary,
          secondary: secondary,
          inversePrimary: inversePrimary,
          error: errorPrimary,
        ),
        iconTheme: IconThemeData(color: Colors.red[50]),
        textTheme: theme.textTheme.copyWith(
          titleSmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: inversePrimary,
            backgroundColor: primary,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _transactions = [
    Transaction(
      id: 'T1',
      title: 'Notebook Nitro 5',
      value: 1300.00,
      date: DateTime.now(),
    ),
    Transaction(
      id: 'T2',
      title: 'Notebook Samsung',
      value: 895.52,
      date: DateTime.now(),
    )
  ];

  _addTransaction(String description, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: description,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //close popup
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Despesas Pessoais"),
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () => _openTransactionFormModal(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Grafico
            Container(
              child: Card(
                color: Colors.blue,
                child: Text('Grafico'),
                elevation: 5,
              ),
            ),
            TransactionList(_transactions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: IconTheme.of(context).color,
        ),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
