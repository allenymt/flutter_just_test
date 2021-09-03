/// do what
/// @author yulun
/// @since 2021-08-28 17:16

void main(){
  smaple1();
}

void smaple1() {
  List<TestClass> testStr =[];
  TestClass t1 = new TestClass();
  // t1.aa = "1";
  testStr.add(t1);
  // first直接抛错了，？也没用，因为在读取first的时候就抛错了
  print("${testStr?.first?.aa}");
}

class TestClass {
  String aa;
}