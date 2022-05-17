import 'package:flutter/material.dart';

class TesPrivacyClipBoard extends StatefulWidget {
  final String signature;

  TesPrivacyClipBoard()
      : signature = "";

  @override
  _TesPrivacyClipBoardState createState() => _TesPrivacyClipBoardState();
}

class _TesPrivacyClipBoardState extends State<TesPrivacyClipBoard> {
  bool isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormFieldState<String>> _introduceKey = GlobalKey();

  final int maxLength = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.center,
                child: Text(
                  "取消",
                  style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                ),
              ),
            ),
            title: Text('测试输入文案'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Builder(
              builder: (context) => Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Builder(
                  builder: (context) => Column(
                    children: <Widget>[_textField(context)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField(BuildContext context) {
    return TextFormField(
      key: _introduceKey,
      controller: TextEditingController(),
      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '说说你的喜好、专业和特长，举个栗子：宇宙无敌rua娃专家、史莱姆顶级推广大使、网上冲浪一级运动员...',
        hintStyle: TextStyle(color: Color(0xFFCBCDD3), fontSize: 15),
        counterStyle: TextStyle(
          color: Color(0xFF999999),
          fontSize: 12,
        ),
      ),
      onEditingComplete: () {},
      onChanged: (_) {},
    );
  }
}
