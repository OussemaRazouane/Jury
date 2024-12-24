import 'package:flutter/material.dart';
import 'package:jury/constants/constant.dart';

class CustomField extends StatefulWidget {
final TextEditingController value;
final GlobalKey<FormState> txtKey;
final String name;
final TextInputType type;
// true if you want to verify the input or false otherwise.
final IconData icon;

  const CustomField({
    super.key,
    required this.txtKey,
    required this.value,
    required this.name,
    required this.type, 
    required this.icon,
  });
  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.txtKey,
      child: TextFormField(
          controller: widget.value,
          keyboardType: widget.type,
          decoration: InputDecoration(
            labelText: widget.name,
            hintText: "Enter ${widget.name}",
            focusColor: const Color.fromARGB(255, 214, 197, 141),
            hoverColor: const Color.fromARGB(255, 203, 192, 158),
            // fillColor: textColor,
            filled: true,
            enabled: true,
            labelStyle:const TextStyle(color:textColor ,fontWeight: FontWeight.bold) ,
            hintStyle:const TextStyle(color: textColor),

            prefixIcon: Icon(widget.icon,color: textColor ,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: textColor, width: 2.5),
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return "${widget.name}  is required";
            }
            return null;
          }),
    );
  }
}
