import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      required this.hintText,
      required this.validator,
      this.onSaved,
      this.obsecureText = false,
      this.keyBoardType = TextInputType.text,
      this.icon,
      this.controller,
      this.initalValue});

  final bool obsecureText;
  final String hintText;
  final String? initalValue;
  final Icon? icon;
  final TextInputType keyBoardType;
  final TextEditingController? controller;

  final Function(String? value) validator;
  final Function(String? value)? onSaved;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool? _secure;

  @override
  void initState() {
    super.initState();
    if (widget.obsecureText == true) {
      _secure = true;
    } else {
      _secure = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyBoardType,
      obscureText: _secure!,
      initialValue: widget.initalValue,
      decoration: InputDecoration(
          prefixIcon: widget.icon,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.titleMedium,
          suffixIcon: widget.obsecureText
              ? GestureDetector(
                  child: Icon(
                    _secure == true
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                  onTap: () {
                    setState(() {
                      _secure = !_secure!;
                    });
                  },
                )
              : null,
          filled: true,
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
            borderSide: BorderSide(color: Colors.grey[350]!),
          )),
      style: Theme.of(context).textTheme.titleMedium,
      validator: (value) => widget.validator(value),
      onSaved: (newValue) => widget.onSaved ?? (newValue),
    );
  }
}
