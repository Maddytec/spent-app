import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spent/components/chart.dart';
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
    final errorPrimary = Colors.redAccent[700];

    return MaterialApp(
      home: MyHomePage(),
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: primary,
          secondary: secondary,
          inversePrimary: inversePrimary,
          error: errorPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: primary,
          headerForegroundColor: inversePrimary,
          elevation: 20,
          shadowColor: primary,
          backgroundColor: inversePrimary,
        ),
        cardTheme: CardTheme(
          color: inversePrimary,
          shadowColor: primary,
          elevation: 6,
        ),
        iconTheme: IconThemeData(
          color: inversePrimary,
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primary;
            }
            return secondary;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primary;
            }
            return inversePrimary;
          }),
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return secondary;
            }
            return secondary;
          }),
        ),
        iconButtonTheme: IconButtonThemeData(),
        textTheme: theme.textTheme.copyWith(
          titleSmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primary,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        listTileTheme: ListTileThemeData(
          style: ListTileStyle.list,
          textColor: primary,
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
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String description, double value, DateTime transactionDate) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: description,
      value: value,
      date: transactionDate,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //close popup
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        "Despesas Pessoais",
      ),
      backgroundColor: AppBarTheme.of(context).backgroundColor,
      actions: [
        if (isLandscape)
          IconButton(
            icon: Icon(
              (_showChart ? Icons.list : Icons.pie_chart),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              // Grafico
              Container(
                height: availableHeight * (isLandscape ? 0.75 : 0.25),
                child: Chart(recentTransaction: _recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.9 : 0.7),
                child: TransactionList(
                  transactions: _transactions,
                  onRemove: _removeTransaction,
                ),
              ),
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
