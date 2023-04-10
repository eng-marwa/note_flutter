import 'package:flutter/material.dart';

extension SnackExt on Widget{
  void showSnackMessage(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}