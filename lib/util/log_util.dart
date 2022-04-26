/// do what
/// @author yulun
/// @since 2022-04-24 16:35
class FlutterTestLog {
  static final tag = "flutter_test";
  static void i(String msg) {
    print("$tag msg:${msg ?? ""}");
  }

  static void e(String msg) {
    print("error: $tag msg:${msg ?? ""}");
  }
}
