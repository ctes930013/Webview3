import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //定義webview的url
  final String url = "http://192.168.0.11/flutter";
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onWebViewCreated: (controller) {
          webController(controller);
        },
        onLoadStart: (controller, url) {},
        onLoadStop: (controller, url) {},
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //webview的控制器
  InAppWebViewController webController(controller) {
    _controller = controller
      ..addJavaScriptHandler(
        //監聽web端傳入的值
        handlerName: 'to_js',
        callback: (data) {
          print("由js傳入的值: $data");
        },
      )
      ..addJavaScriptHandler(
        //監聽web端傳入的值
        handlerName: 'is_finish_load',
        callback: (data) {
          print("加載準備完成...");
          //傳值給web端
          String code = "window.receiveData('$url')";
          controller.evaluateJavascript(source: code).then((result) {});
          //傳list map給web端
          Map<String, String> map1 = {
            "key": "122",
            "value": "ssss",
          };
          Map<String, String> map2 = {
            "key": "taiwan",
            "value": "mmm",
          };
          List<String> param = [
            "'${json.encode(map1)}'",
            "'${json.encode(map2)}'"
          ];
          print(param.toString());
          String code2 = "window.receiveListMapData($param)";
          controller.evaluateJavascript(source: code2).then((result) {});
          //傳int給web端
          int id = 100;
          String code3 = "window.receiveIntData($id)";
          controller.evaluateJavascript(source: code3).then((result) {});
        },
      );
    return _controller;
  }
}
