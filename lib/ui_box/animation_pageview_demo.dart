import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_box/util/util.dart';
import 'package:flutter_ui_box/widget/base/animation_height_wrapper.dart';

/// do what
/// @author yulun
/// @since 2020-09-01 10:12
class AnimationPageViewWidget extends StatefulWidget {
  @override
  State<AnimationPageViewWidget> createState() {
    return _AnimationPageViewWidgetState();
  }
}

class _AnimationPageViewWidgetState extends State<AnimationPageViewWidget> {
  List<double> _imgScaleMap = [0.8, 0.7, 1.0, 0.9, 1.2, 1.5];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> pics = parsePics();
    if (isEmpty(pics)) {
      return Container();
    }

    Widget child = AnimationHeightViewWidget<PageView>(
      pageViewChild: PageView.builder(
        itemCount: pics.length,
        controller: PageController(),
        itemBuilder: (context, index) {
          String imgUrl = pics.elementAt(index);
          double w = MediaQuery.of(context).size.width;
          double h = w * calculateImgScale(index);
          return GestureDetector(
            onTap: () {
              print("tap img index is $index");
            },
            child: Image.network(imgUrl,
                width: w,
                height: h,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      itemCount: pics.length,
      currentPageIndex: _currentIndex,
      computeAspectRadio: (index) {
        return calculateImgScale(index!);
      },
      notifyScroll: (scrollNotification) {},
    );

    child = Stack(
      children: <Widget>[
        child,
        Visibility(
          visible: (pics.length) > 1,
          child: Positioned(
            bottom: 18,
            right: 15,
            child: Text.rich(TextSpan(
              children: [
                TextSpan(
                    text: "${_currentIndex + 1}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                TextSpan(
                    text: "/${pics.length}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black))
              ],
            )),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("高度自适应选择框"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          child,
          Expanded(
            child: Container(
              color: Colors.yellow,
              alignment: Alignment.center,
              child: Text(
                "我是占位的",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> parsePics() {
    return [
      "https://ww1.sinaimg.cn/large/0065oQSqly1fu7xueh1gbj30hs0uwtgb.jpg",
      "https://ww1.sinaimg.cn/large/0065oQSqgy1fu39hosiwoj30j60qyq96.jpg",
      "https://ww1.sinaimg.cn/large/0065oQSqly1ftzsj15hgvj30sg15hkbw.jpg",
      "https://ww1.sinaimg.cn/large/0065oQSqly1ftzsj15hgvj30sg15hkbw.jpg",
      "https://ww1.sinaimg.cn/large/0065oQSqly1ftu6gl83ewj30k80tites.jpg",
      "https://ww1.sinaimg.cn/large/0065oQSqgy1ftwcw4f4a5j30sg10j1g9.jpg",
    ];
  }

  // 每张图片的宽高比
  double calculateImgScale(int index) {
    return _imgScaleMap[index];
  }
}
