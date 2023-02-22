import 'package:flutter/material.dart';

/// 登录动效
class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({Key? key, required this.protect}) : super(key: key);

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          const Image(
            fit: BoxFit.cover,
            image: AssetImage("images/logo.png"), width: 90, height: 70,),
          _image(false)
        ],
      ),
    );
  }

  _image(bool left) {
    var headLeft = widget.protect
        ? "images/head_left_protect.png"
        : "images/head_left.png";
    var headRight = widget.protect
    ? "images/head_right_protect.png"
    : "images/head_right.png";
    return Image(
      fit: BoxFit.contain,
      image: AssetImage(left?headLeft: headRight), 
      height: 90
    );
  }
}
