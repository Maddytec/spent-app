import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spent/components/adaptative_button.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmint;

  TransactionForm(this.onSubmint);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final description = _descriptionController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (description.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmint(description, value, _selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then(
      (datePicker) {
        if (datePicker == null) {
          return;
        }
        setState(() {
          _selectedDate = datePicker;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            //Description
            TextField(
              controller: _descriptionController,
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
              controller: _valueController,
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
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Selecionar data',
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //New Trasaction
                AdaptativeButton(
                    label: 'Guardar Transação', onPressed: _submitForm)
                // ElevatedButton(
                //   style: TextButton.styleFrom(
                //     foregroundColor:
                //         Theme.of(context).colorScheme.inversePrimary,
                //     backgroundColor: Theme.of(context).colorScheme.primary,
                //   ),
                //   onPressed: _submitForm,
                //   child: const Text('Guardar Transação'),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
