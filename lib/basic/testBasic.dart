/// do what
/// @author yulun
/// @since 2020-05-14 22:15
class TestPrivate {
  int? _a;
  var _b;

  set a(int? value) {
    _a = value;
  }

  int? get a => _a;


}

class TestPrivateImport {
  final TestPrivate testPrivate;

  TestPrivateImport(this.testPrivate) {
    testPrivate._a = 1;
  }
}
