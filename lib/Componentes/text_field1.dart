import 'package:flutter/material.dart';

class TextInput1 extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  const TextInput1({
    Key? key,
    required this.controller,
    required this.hint,
    required this.obscureText,
  }) : super(key: key);

  @override
  _TextInput1State createState() => _TextInput1State();
}

class _TextInput1State extends State<TextInput1> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_isVisible,
        style: TextStyle(color: Colors.yellow.shade200), // Cambiar el color del texto ingresado a amarillo claro
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow.shade800,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: Colors.transparent.withOpacity(0.5),
          filled: true,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.orange),
          suffixIcon: widget.obscureText
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
          // Añadir efecto de sombra alrededor del campo de texto
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          // Añadir animación de color de enfoque
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade800,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
