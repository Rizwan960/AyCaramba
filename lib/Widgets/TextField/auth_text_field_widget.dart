import 'package:ay_caramba/Utils/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexpattern/regexpattern.dart';

class AuthTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Icon leadingIcon;
  final TextInputType textInputType;
  final String hintText;
  final FocusNode nextFocusNode;
  final bool isLastField;
  bool validationReqired;
  bool? showPassword;
  final TextInputAction textInputAction;

  AuthTextFieldWidget(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.leadingIcon,
      required this.textInputType,
      required this.hintText,
      required this.nextFocusNode,
      required this.isLastField,
      this.showPassword,
      required this.validationReqired,
      required this.textInputAction});

  @override
  State<AuthTextFieldWidget> createState() => _AuthTextFieldWidgetState();
}

class _AuthTextFieldWidgetState extends State<AuthTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.showPassword ?? false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[a-zA-Z0-9]+$')), // Allow only letters and digits
      ],
      controller: widget.controller,
      textCapitalization: widget.hintText == "Email Address" ||
              widget.hintText == "Password" ||
              widget.hintText == "Confirm Password"
          ? TextCapitalization.none
          : TextCapitalization.words,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      cursorColor: AppColors.blackColor,
      validator: !widget.validationReqired
          ? (value) {
              return null;
            }
          : (value) {
              if (value!.isEmpty) {
                return "field is required";
              }
              if ((widget.hintText == "Username" ||
                      widget.hintText == "Name") &&
                  value.length < 3) {
                return "must be greater then 3 characters";
              }

              if (widget.hintText == "Email Address" && !value.isEmail()) {
                return "invalid email";
              }
              if ((widget.hintText == "Password" ||
                      widget.hintText == "Confrim Password") &&
                  value.length < 8) {
                return "must be greater then 8 characters";
              }

              return null;
            },
      onEditingComplete: widget.isLastField
          ? () {
              FocusScope.of(context).requestFocus();
            }
          : () {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        suffixIcon: widget.showPassword == null
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    widget.showPassword = !widget.showPassword!;
                  });
                },
                icon: widget.showPassword!
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
              ),
        prefixIcon: widget.leadingIcon,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        labelText: widget.hintText,
        labelStyle: const TextStyle(color: Colors.grey),
        // fillColor: AppColors.whiteColor,
        // filled: true,
        contentPadding: const EdgeInsets.all(20),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
