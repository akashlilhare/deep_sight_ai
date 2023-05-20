import 'package:flutter/material.dart';

class AuthInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType? inputType;
  final TextEditingController inputController;

  const AuthInputField(
      {Key? key,
      required this.label,
      required this.inputType,
      required this.hintText,
      required this.inputController})
      : super(key: key);

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            style: TextStyle(color: Colors.black),
            obscureText:
                widget.label.toLowerCase() != "password" ? false : _isHidden,
            controller: widget.inputController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              suffix: widget.label.toLowerCase() == "password"
                  ? InkWell(
                      onTap: () {
                        _isHidden = !_isHidden;
                        setState(() {});
                      },
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            keyboardType: widget.inputType,
          ),
        ),
      ],
    );
  }
}
