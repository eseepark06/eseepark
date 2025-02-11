import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

class CustomTextFieldWithLabel extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String placeholder;
  final TextStyle titleStyle;
  final TextStyle placeholderStyle;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;

  const CustomTextFieldWithLabel({
    super.key,
    this.controller,
    required this.title,
    required this.placeholder,
    required this.titleStyle,
    required this.placeholderStyle,
    this.onChanged,
    this.backgroundColor,
    this.verticalPadding,
    this.horizontalPadding
  });

  @override
  State<CustomTextFieldWithLabel> createState() => _CustomTextFieldWithLabelState();
}

class _CustomTextFieldWithLabelState extends State<CustomTextFieldWithLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.title,
                  style: widget.titleStyle
                )
              ]
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              fillColor: widget.backgroundColor,
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? screenHeight * 0.01,
                horizontal: widget.horizontalPadding ?? screenWidth * 0.02
              )
            ),
          ),
        ],
      ),
    );
  }
}
