import 'package:flutter/material.dart';

class PlainFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const PlainFormTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.leadingIcon,
    this.trailingIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
          suffixIcon: trailingIcon != null ? Icon(trailingIcon) : null,
        ),
        validator: validator,
        onChanged: onChanged,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
