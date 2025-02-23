import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/general/theme_provider.dart';
import '../providers/root_provider.dart';

class CustomTextFieldWithLabel extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String placeholder;
  final TextStyle titleStyle;
  final TextStyle placeholderStyle;
  final TextStyle? mainTextStyle;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? borderRadius;
  final double? borderWidth;
  final Color? disabledBorderColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? cursorColor;

  const CustomTextFieldWithLabel({
    super.key,
    this.controller,
    required this.title,
    required this.placeholder,
    required this.titleStyle,
    required this.placeholderStyle,
    this.mainTextStyle,
    this.onChanged,
    this.backgroundColor,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderRadius,
    this.borderWidth,
    this.disabledBorderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor
  });

  @override
  State<CustomTextFieldWithLabel> createState() => _CustomTextFieldWithLabelState();
}

class _CustomTextFieldWithLabelState extends State<CustomTextFieldWithLabel> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      child: Theme(
        data: themeProvider.currentTheme.copyWith(
          textTheme: themeProvider.currentTheme.textTheme.apply(
            fontFamily: 'Poppins',
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: screenWidth * 0.03),
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
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: widget.mainTextStyle,
              cursorColor: widget.cursorColor,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: widget.placeholderStyle,
                fillColor: widget.backgroundColor,
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.verticalPadding ?? screenHeight * 0.01,
                    horizontal: widget.horizontalPadding ?? screenWidth * 0.02
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: BorderSide(
                        color: widget.disabledBorderColor ?? Colors.transparent,
                        width: widget.borderWidth ?? 0.0
                    )
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: BorderSide(
                        color: widget.disabledBorderColor ?? Colors.transparent,
                        width: widget.borderWidth ?? 0.0
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: BorderSide(
                        color: widget.enabledBorderColor ?? Colors.transparent,
                        width: widget.borderWidth ?? 0.0
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                    borderSide: BorderSide(
                        color: widget.focusedBorderColor ?? Colors.transparent,
                        width: widget.borderWidth ?? 0.0
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextStyle? mainTextStyle;
  final Function(String)? onChanged;
  final Function(bool)? call;
  final Function(String?)? onSubmit;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? borderRadius;
  final double? borderWidth;
  final Color? disabledBorderColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Widget? prefixWidget;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Color? cursorColor;
  final bool? clearText;
  final bool? isDense;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.placeholderStyle,
    this.mainTextStyle,
    this.onChanged,
    this.call,
    this.onSubmit,
    this.backgroundColor,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderRadius,
    this.borderWidth,
    this.disabledBorderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.prefixWidget,
    this.prefixIcon,
    this.suffixIcon,
    this.cursorColor,
    this.clearText,
    this.isDense,
    this.textInputAction
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Add listener to detect focus changes
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print("TextField Focused");
        // Run any function when the text field is clicked (focused)
        widget.call?.call(true);
      } else {
        print("TextField Unfocused");
        widget.call?.call(false);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          focusNode: _focusNode, // Assign the FocusNode
          controller: widget.controller,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmit,
          style: widget.mainTextStyle,
          cursorColor: widget.cursorColor,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: widget.placeholderStyle,
            fillColor: widget.backgroundColor,
            isDense: widget.isDense ?? true,
            filled: true,
            prefix: widget.prefixWidget,
            prefixIcon: widget.prefixIcon,
            contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? screenHeight * 0.01,
                horizontal: widget.horizontalPadding ?? screenWidth * 0.02
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                borderSide: BorderSide(
                    color: widget.disabledBorderColor ?? Colors.transparent,
                    width: widget.borderWidth ?? 0.0
                )
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                borderSide: BorderSide(
                    color: widget.disabledBorderColor ?? Colors.transparent,
                    width: widget.borderWidth ?? 0.0
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                borderSide: BorderSide(
                    color: widget.enabledBorderColor ?? Colors.transparent,
                    width: widget.borderWidth ?? 0.0
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                borderSide: BorderSide(
                    color: widget.focusedBorderColor ?? Colors.transparent,
                    width: widget.borderWidth ?? 0.0
                )
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          right: screenWidth * 0.04,
          child: (widget.clearText == true && widget.controller != null && widget.controller!.text.trim().isNotEmpty)
              ? GestureDetector(
            onTap: () {
              setState(() {
                widget.controller?.clear();
              });
              widget.call?.call(true);
            },
            child: Icon(Icons.close, size: screenWidth * 0.05),
          )
              : widget.suffixIcon ?? SizedBox.shrink(),
        )
      ],
    );
  }
}

