/// do what
/// @author yulun
/// @since 2021-02-22 17:59
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomSheetPageRoute extends StatefulWidget {

  BottomSheetPageRoute();

  @override
  State<StatefulWidget> createState() {
    return BottomSheetPageRouteState();
  }
}

class BottomSheetPageRouteState extends State<BottomSheetPageRoute> {
  Map<String, dynamic> resultMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.of(context).pop();
          },
        ));
  }

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black12,
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.yellow,
            child: Text("12324"),
          );
        },
        //这里会报leak why?
      ).whenComplete(() => Navigator.of(context).pop(resultMap));
    });
  }
}
