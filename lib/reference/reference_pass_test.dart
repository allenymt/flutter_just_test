/// do what
/// @author yulun
/// @since 2021-03-22 19:08
// 基本类型 int String double bool 值传递
// 其他类型 引用传递
// but 说好的一切皆为类呢
class TestReference {
  void test() {
    int a=1;
    String b = "123";
    double c = 2;
    bool d = false;
    TestClass testClass = TestClass();
    test1(a,b,c,d,testClass);
    print("456456");
  }

  void test1(int aa,String bb,double cc,bool dd,TestClass testClass) {
      aa= 3;
      bb="456";
      cc =4;
      dd = true;
      testClass.mInt +=1;
      testClass.mStr = "str1";
      testClass.mDouble+=3;
      testClass.testClassChild.mIntChild+=2;
      testClass.testClassChild.mStrChild = "123456";
      testClass.testMap1["123"]="12345";
      TestClassChild child = testClass.testMap1["456"];
      child.mIntChild+=4;

      print("123123123");
  }


}

class TestClass {
  late int mInt;
  String? mStr;
  late double mDouble;
  late TestClassChild testClassChild;
  Map<String, dynamic> testMap1 = {};

  TestClass() {
    mInt = 1;
    mStr = "str";
    mDouble = 2;
    testClassChild = new TestClassChild();
    testMap1["123"] = "1234";
    testMap1["456"] = new TestClassChild();
  }
}

class TestClassChild {
  late int mIntChild;
  String? mStrChild;
  double? mDoubleChild;

  TestClassChild() {
    mIntChild = 3;
    mStrChild = "strChild";
    mDoubleChild = 4;
  }
}
