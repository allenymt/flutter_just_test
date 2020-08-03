package com.example.flutter_just_test;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @author yulun
 * @sinice 2020-06-29 19:09
 */
class SampleViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    public SampleViewFactory(BinaryMessenger msger) {
        super(StandardMessageCodec.INSTANCE);
        messenger = msger;
    }
    @Override
    public PlatformView create(Context context, int id, Object obj) {
        return new SimpleViewControl(context, id, messenger);
    }
}