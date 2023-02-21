import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChange;
  final bool lineStretch;
  final bool isSecretText;
  final TextInputType keyboardType;

  const LoginInput([
    this.onChanged,
    this.focusChange,
    this.lineStretch = false,
    this.isSecretText = false,
    this.keyboardType = TextInputType.number, 
    key,
    this.title = "",
    this.hint = "",
  ]) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 是否获取光标监听
    _focusNode.addListener(() {
        // ignore: avoid_print, invalid_use_of_protected_member
        print("has focus${_focusNode.hasListeners}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
