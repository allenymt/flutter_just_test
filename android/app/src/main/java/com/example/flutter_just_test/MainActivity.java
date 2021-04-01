package com.example.flutter_just_test;

import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private String sharedText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//    GeneratedPluginRegistrant.registerWith(this);


//    registerIntent();
//
//    registerPlatformView();
    }

//  void registerPlatformView(){
//    Registrar registrar = registrarFor("com.hangchen/NativeViews");
//    SampleViewFactory playerViewFactory = new SampleViewFactory(registrar.messenger());
//    registrar.platformViewRegistry().registerViewFactory("SampleView", playerViewFactory);
//  }
//
//  void registerIntent(){
//    Intent intent = getIntent();
//    String action = intent.getAction();
//    String type = intent.getType();
//    if (Intent.ACTION_SEND.equals(action) && type != null) {
//      if ("text/plain".equals(type)) {
//        // Handle text being sent
//        handleSendText(intent);
//      }
//    }
//
//    new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
//            new MethodChannel.MethodCallHandler() {
//              @Override
//              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//                if (call.method.contentEquals("getSharedText")) {
//                  result.success(sharedText);
//                  sharedText = null;
//                }
//              }
//            });
//  }
//  void handleSendText(Intent intent) {
//    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
//  }
}
