import 'package:flutter/material.dart';
import '../util/color.dart';
// ignore: must_be_immutable
class LoginInput extends StatefulWidget {
  final String title;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChange;
  final bool lineStretch;
  final bool isSecretText;
  String? defaultValue;
  final TextInputType keyboardType;

  LoginInput(
    this.title, {
    this.hint,
    this.onChanged,
    this.focusChange,
    this.lineStretch = false,
    this.isSecretText = false,
    this.defaultValue,
    this.keyboardType = TextInputType.name,
    key,
  }) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 光标监听
    _focusNode.addListener(() {
      // ignore: avoid_print, invalid_use_of_protected_member
      if (widget.focusChange != null) {
        widget.focusChange!(_focusNode.hasFocus);
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
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: const Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.isSecretText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.isSecretText,
      cursorColor: primary,
      autocorrect: false,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
    ));
  }
}
