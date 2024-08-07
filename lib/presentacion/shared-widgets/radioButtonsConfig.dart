import 'package:flutter/material.dart';

class RadioButtonsHost extends StatefulWidget {
  final Function getValue;

  const RadioButtonsHost({super.key, required this.getValue});
  @override
  _RadioButtonsHostState createState() => _RadioButtonsHostState();
}

class _RadioButtonsHostState extends State<RadioButtonsHost> {
  // Variable to keep track of the selected radio button
  String? _selectedOption = 'host';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'host',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  widget.getValue(value);
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              const Text('Por defecto'),
              const SizedBox(
                width: 200,
              ),
              Radio<String>(
                value: 'manual',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  widget.getValue(value);
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              const Text('Manual'),
            ],
          ),
        ],
      ),
    );
  }
}
