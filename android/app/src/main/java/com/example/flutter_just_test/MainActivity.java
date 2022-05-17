package com.example.flutter_just_test;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.yl.lib.sentry.hook.PrivacyResultCallBack;
import com.yl.lib.sentry.hook.PrivacySentry;
import com.yl.lib.sentry.hook.PrivacySentryBuilder;

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
        initPrivacy();
    }

    void initPrivacy(){
        PrivacySentryBuilder builder = new PrivacySentryBuilder()
                // 自定义文件结果的输出名
                .configResultFileName("buyer_privacy")
                // 配置游客模式，true打开游客模式，false关闭游客模式
                .configVisitorModel(false)
                // 配置写入文件日志 , 线上包这个开关不要打开！！！！，true打开文件输入，false关闭文件输入
                .enableFileResult(true)
                // 持续写入文件30分钟
                .configWatchTime(30 * 60 * 1000)
                // 文件输出后的回调
                .configResultCallBack(new PrivacyResultCallBack() {

                    @Override
                    public void onResultCallBack(@NonNull String s) {

                    }
                });
        // 添加默认结果输出，包含log输出和文件输出
        PrivacySentry.Privacy.INSTANCE.init(getApplication(), builder);
    }
//  void registerPlatformView(){
//    Registrar registrar = registrarFor("com.hangchen/NativeViews");
//    SampleViewFactory playerViewFactory = new SampleViewFactory(registrar.messenger());
//    registrar.platformViewRegistry().registerViewFactory("SampleView", playerViewFactory);
//  }

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
