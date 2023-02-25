import 'package:fluttertoast/fluttertoast.dart';

void showWarnToast(String text) {
  Fluttertoast.showToast(
      msg: text, 
      toastLength: Toast.LENGTH_LONG, 
      gravity: ToastGravity.CENTER,
  );
}

void showToast(String text) {
  Fluttertoast.showToast(
      msg: text, 
      toastLength: Toast.LENGTH_LONG, 
      gravity: ToastGravity.CENTER,
  );
}
