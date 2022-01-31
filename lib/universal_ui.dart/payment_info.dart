import 'package:flutter/material.dart';

class PaymentPicker extends StatefulWidget {
  PaymentPicker({Key? key, required this.chnagePayment, required this.selected})
      : super(key: key);
  Function(String) chnagePayment;
  String selected;
  @override
  _PaymentPickerState createState() => _PaymentPickerState();
}

class _PaymentPickerState extends State<PaymentPicker> {
  @override
  Widget build(BuildContext context) {
    String selected = widget.selected;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: DropdownButton(
              underline: null,
              elevation: 0,
              onChanged: (String? value) {
                widget.chnagePayment(value ?? "cash");
                setState(() {
                  selected = value!;
                });
              },
              value: selected,
              items: [
                'Cash',
                'Check',
                'Paypal',
                'Zelle',
                'Google Pay',
                'Apple Pay',
                'Venmo',
                'Square',
                'Other'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )),
    );
  }
}
