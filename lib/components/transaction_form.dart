import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmint;

  TransactionForm(this.onSubmint);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final descriptionController = TextEditingController();

  final valueController = TextEditingController();

  _submitForm() {
    final description = descriptionController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (description.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmint(description, value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              //Description
              TextField(
                controller: descriptionController,
                onSubmitted: (_) => _submitForm,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  labelText: 'Descrição',
                ),
              ),
              // Value
              TextField(
                controller: valueController,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), //enable numeric keyboard
                onSubmitted: (_) => _submitForm,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  labelText: 'Valor (R\$)',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //New Trasaction
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _submitForm,
                    child: Text('Guardar Transação'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
