package com.vanina.vanevents;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new FirebaseMessagingPlugin());
    //flutterEngine.getPlugins().add(new E2EPlugin());
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
