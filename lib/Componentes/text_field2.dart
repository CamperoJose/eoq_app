import 'package:flutter/material.dart';

class TextInputForm extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;

  const TextInputForm({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  _TextInputFormState createState() => _TextInputFormState();
}

class _TextInputFormState extends State<TextInputForm> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: TextField(
  controller: widget.controller,
  obscureText: widget.labelText == 'Password' && !_isVisible,
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    prefixIcon: Icon(
      widget.prefixIcon,
      color: Colors.orange,
    ),
    labelText: widget.labelText,
    labelStyle: const TextStyle(color: Colors.orange), // Cambiar el color del texto del label a negro
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.orange,
      ),
    ),
    fillColor: Colors.transparent.withOpacity(0.5),
    filled: true,
    hintText: widget.labelText,
    hintStyle: const TextStyle(color: Colors.white),
    suffixIcon: widget.labelText == 'Password'
        ? IconButton(
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.orange,
            ),
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
          )
        : null,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.redAccent,
      ),
    ),
  ),
)

    );
  }
}
