import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormfield extends StatefulWidget {
  const DatePickerFormfield(
      {super.key,
      required this.text,
      required this.validator,
      required this.onSaved,
      this.currentValue,
      this.isProfileView});

  final String text;
  //final Function(DateTime) onPickedDate;
  final Function(String? value) validator;
  final Function(String? value) onSaved;
  final DateTime? currentValue;
  final bool? isProfileView;
  @override
  State<DatePickerFormfield> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DatePickerFormfield> {
  TextEditingController dateinput = TextEditingController();
  late final bool _isProfileView;

  @override
  void initState() {
    super.initState();
    if (widget.currentValue != null) {
      final DateFormat format = DateFormat('dd-MM-yyyy');

      dateinput.text = format.format(widget.currentValue!);
    }
    if (widget.isProfileView != null) {
      _isProfileView = widget.isProfileView!;
    } else {
      _isProfileView = false;
    }
  }

  @override
  void dispose() {
    dateinput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => widget.validator(value),
      onSaved: (newValue) => widget.onSaved(newValue),
      style: Theme.of(context).textTheme.titleMedium,
      readOnly: true,
      controller: dateinput,
      decoration: _isProfileView
          ? InputDecoration(
              labelText: 'Date of birth',
              hintText: widget.text,
              hintStyle: Theme.of(context).textTheme.titleMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            )
          : InputDecoration(
              prefixIcon: const Icon(Icons.calendar_month),
              hintText: widget.text,
              hintStyle: Theme.of(context).textTheme.titleMedium,
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              )),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                1900), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime.now());

        if (pickedDate != null) {
          //pickedDate output format => 18-02-2024 00:00:00.000
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement
          widget.onSaved(formattedDate);
          setState(() {
            dateinput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          //print("Date is not selected");
        }
      },
    );
  }
}
