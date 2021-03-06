import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final VoidCallback onPageExit;
  const WebViewScreen({
    Key? key,
    required this.url,
    required this.onPageExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late WebViewController controllerGlobal;
    final CookieManager cookieManager = CookieManager();

    Future<bool> _exitApp(BuildContext context) async {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return false;
      } else {
        controllerGlobal.clearCache();
        cookieManager.clearCookies();
        onPageExit();
        return Future.value(true);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return _exitApp(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Image Search"),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () async {
                if (await controllerGlobal.canGoBack()) {
                  controllerGlobal.goBack();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () async {
                if (await controllerGlobal.canGoForward()) {
                  controllerGlobal.goForward();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async{
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication
                );
              },
            ),
          ],
        ),
        body: WebView(
          initialUrl: url,
          onPageFinished: (_) {
            onPageExit();
          },
          gestureNavigationEnabled: true,
          onWebViewCreated: (controller) {
            controllerGlobal = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
