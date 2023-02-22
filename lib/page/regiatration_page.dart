import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:flutter_bili/widget/login_button.dart';
import 'package:flutter_bili/widget/login_input.dart';

import '../util/string_util.dart';
import '../util/toast.dart';
import '../widget/appbar.dart';
import '../widget/login_Effect.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;

  const RegistrationPage({this.onJumpToLogin, key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imooocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", widget.onJumpToLogin),
      body: ListView(
        children: [
          LoginEffect(protect: protect),
          LoginInput("用户名", hint: "请输入用户名", onChanged: (text) {
            userName = text;
            checkInput();
          }),
          LoginInput(
            "密码",
            hint: "请输入密码",
            isSecretText: true,
            lineStretch: false,
            onChanged: (text) {
              password = text;
              checkInput();
            },
            focusChange: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          LoginInput(
            "确认密码",
            hint: "请再次输入密码",
            isSecretText: true,
            lineStretch: true,
            onChanged: (text) {
              rePassword = text;
              checkInput();
            },
            focusChange: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: LoginButton(
                title: "注册",
                enable: loginEnable,
                onPress: send,
              )),
        ],
      ),
    );
  }

  // 检查注册按钮是否应该高亮
  checkInput() {
    bool enable = false;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    if (!loginEnable) {
      return;
    }
    if (password != rePassword) {
      showToast("两次密码输入不一致");
      return;
    }

    try {
      var result =
          await LoginDao.registation(userName!, password!, "3234", "1233");
      if (result["code"] == 0) {
        showToast("注册成功");
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin!();
        }
      } else {
        showToast("注册失败：${result.message}");
      }
    } on HiNetError catch (e) {
      print("注册失败:${e.code}");
      showToast("注册失败：${e.message}");
    }
  }
}
