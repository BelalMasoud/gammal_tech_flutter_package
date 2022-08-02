library gammal_tech;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:galleryimage/galleryimage.dart';
part 'users_app.dart';

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
