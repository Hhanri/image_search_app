import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final PageFinishedCallback onPageFinished;
  const WebViewScreen({
    Key? key,
    required this.url,
    required this.onPageFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPageFinished(url);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Image Search"),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async{
                await launch(url);
              },
            ),
          ],
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: onPageFinished,
        ),
      ),
    );
  }
}
