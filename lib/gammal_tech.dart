library gammal_tech;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GammalTech {
  static MaterialApp webviewApp(String appTitle, String url,
          {MaterialColor color = Colors.cyan}) =>
      MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: color),
        home: SafeArea(
            child: Scaffold(
          body: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )),
      );
}
