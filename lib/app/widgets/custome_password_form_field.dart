import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomePasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  const CustomePasswordFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
  }) : super(key: key);

  @override
  State<CustomePasswordFormField> createState() =>
      _CustomePasswordFormFieldState();
}

class _CustomePasswordFormFieldState extends State<CustomePasswordFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white60.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          icon: Icon(widget.icon),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
