package com.example.flutter_just_test;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 * @author yulun
 * @sinice 2020-06-29 19:09
 */
class SimpleViewControl implements PlatformView, MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private View view;

    public SimpleViewControl(Context context, int id, BinaryMessenger messenger) {
        view = new View(context);
        view.setBackgroundColor(Color.rgb(255, 0, 0));

        methodChannel = new MethodChannel(messenger, "samples.chenhang/native_views_" + id);
        methodChannel.setMethodCallHandler(this);

    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("changeBackgroundColor")) {
            view.setBackgroundColor(Color.rgb(0, 0, 255));
            result.success(0);
        } else {
            result.notImplemented();
        }

    }


    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
        methodChannel = null;
        view = null;
    }
}