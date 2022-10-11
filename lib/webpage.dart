import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebPage extends StatefulWidget {
  WebPage({super.key, required this.code});
  String code;
  @override
  State<WebPage> createState() => _WebPageState(code);
}

class _WebPageState extends State<WebPage> {
  late WebViewController controller;
  String host = "https://meomeomeo33335.000webhostapp.com";
  String code = "";
  String file = "link.html";
  String link = "";
  _WebPageState(this.code);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      link = host + "/" + code + "/" + file;
      final jsonString = await http.get(Uri.parse(link));
      print(jsonString.body);
      setState(() {
        controller.loadUrl(jsonString.body);
        link = jsonString.body;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{},
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
      ),
    );
  }
}
