import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/widget/login_input.dart';
import '../http/dao/login_dao.dart';
import '../util/string_util.dart';
import '../util/toast.dart';
import '../widget/appbar.dart';
import '../widget/login_Effect.dart';
import '../widget/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = true;
  String? userName = "hhh";
  String? password = "123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("密码登录", "注册", () {}),
      body: ListView(
        children: [
          LoginEffect(
            protect: protect,
          ),
          LoginInput(
            "用户名", 
            hint: "请输入用户名", 
            defaultValue: "hhh",
            onChanged: (text) {
              userName = text;
              checkInput();
            }
          ),
          LoginInput(
            "密码",
            defaultValue: "123",
            hint: "请输入密码",
            isSecretText: true,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: LoginButton(
              title: "登录",
              enable: loginEnable,
              onPress: send,
            ),
          )
        ],
      ),
    );
  }

  // 检查登录按钮是否应该高亮
  void checkInput() {
    bool enable = false;
    print("${userName}===${password}");
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  // 登录按钮点击
  void send() async {
    if (!loginEnable) {
      showToast("请输入用户名或密码");
      return;
    }
    
    try {
      var result = await LoginDao.login(userName!, password!);
      if (result['code'] == 0) {
        showToast("登录成功");
      } else {
        showWarnToast(result['msg'] ?? "登录失败");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }
}
