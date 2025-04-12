import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> toast(String message, {Color? color}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: color ?? const Color.fromARGB(255, 255, 49, 49),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
