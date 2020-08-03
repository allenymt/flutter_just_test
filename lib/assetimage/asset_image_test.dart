import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-18 11:49

class AssetsImageWidget extends  StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets"),
      ),
    );
  }
}