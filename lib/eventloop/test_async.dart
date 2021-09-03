/// do what
/// @author yulun
/// @since 2021-09-03 11:30

void main(){
  bb();
}

/// 注意。这里有没有return 差别很大
/// 有return，实际返回了一个future，如果调用方有await,就是一个等待效果
/// 没有return, 那就相当于同步执行了一段代码，异步代码会在延迟后再执行
Future<void> awaitTest(String s, Duration duration) {
  return Future.delayed(duration,(){
    print(s);
  });
}

///  执行结果
// async_d
// async_a1
// async_a2
// async_a3
// sync test1
// async_b1
// async_c1
// async_c2
// async_c3
// async_b2
// async_b3
// sync test2
bb() async {
  /// 有await,会等待执行，注意后面的同步代码也不会执行
  await awaitTest('async_d',Duration(seconds: 4));

  /// 等同于 await awaitTest(1);await awaitTest(2);await awaitTest(3);
  /// 就是单步执行
  for (int i = 1; i <= 3; i++) {
    await awaitTest('async_a$i',Duration(seconds: 2));
  }
  /// 同步代码 没什么好说的
  print('sync test1');
  List<int> a = [1,2,3];

  /// 注意foreach的内部，相当于多包了一层function，把await异步效果破坏了，async_c会一起输出3个
  /// 因为等同于执行了三个没有await的Future
  //   void forEach(void f(E element)) {
  //     for (E element in this) f(element);
  //   }
  a.forEach((element) async{
    await awaitTest('async_c$element',Duration(seconds: 1));
  });

  /// 和第一个for循环一样
  for(int i in a){
    await awaitTest('async_b$i',Duration(milliseconds: 888));
  }

  print('sync test2');
}