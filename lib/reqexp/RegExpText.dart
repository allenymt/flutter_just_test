import 'package:flutter/material.dart';

/// do what
/// @author yulun
/// @since 2020-06-23 20:45

class RegExpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Text(
            "RegExp_test",
            style: TextStyle(fontSize: 30),
          ),
          onTap: () {
            testRegexp();
          },
        ),
      ),
    );
  }

  String textText =
      "春光作伴好读书 https://h5.weidian.com/m/circle-h5/share.html为的的的的";
  RegExp regExpLook = RegExp(""
      "("
      " (http|ftp|https)://" //scheme
      ")"
      "("
      " ([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})" //host
      " |"
      " ([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3})"
      ")"
      "(:[0-9]{1,4})" //port
      "*"
      "(/[a-zA-Z0-9\\&%_\\./-~-]*)" //query param
      "*"
      "(#[a-zA-Z0-9\\&%_\\./-~-]*)" //fragment param
      "?");

  // ((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?

  void testRegexp() {
    RegExp regExp = RegExp(
        "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{1,3})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)*(#[a-zA-Z0-9\\&%_\\./-~-]*)?");

    textText = "https://www.baidu.comhttps://www.baidu.com";
    textText = "春光作伴好读书 https://h5123231.weidian123123.com/m/circle-h5/share.html?a=b&b=2#abc=sdf&cdf=123为的的的的";
    String content = textText;
    List<Match> matches = regExp.allMatches(content).toList();
    if (matches.length == 0) {
      print("没有超链接 $content");
    } else {
      //有超链接
      int index = 0;
      for (int i = 0; i < matches.length; i++) {
        Match m = matches[i];
        if (m.start > index) {
          print(
              "链接前缀 ${content.substring(index, m.start > content.length ? content.length : m.start)}");
        }
        String url = content.substring(
            m.start, m.end > content.length ? content.length : m.end);
        print("网页 $url");
        index = m.end;
      }

      if (content.length > index) {
        print("链接后文案 ${content.substring(index, content.length)}");
      }
    }
  }
}
