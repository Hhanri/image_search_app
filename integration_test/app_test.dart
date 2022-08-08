import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:image_search_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> wait() => Future.delayed(const Duration(seconds: 6));

  final Finder image = find.byKey(const Key("Image Widget"));
  final Finder addFileButton = find.byKey(const Key("Add File"));
  final Finder searchButton = find.byKey(const Key("Search"));
  final Finder loadingScreen = find.byKey(const Key("Loading Screen"));
  final Finder webViewScreen = find.byKey(const Key("WebView Screen"));
  final Finder goBackButton = find.byKey(const Key("Go Back"));
  
  testWidgets("check initial state (no image, nothing happens on search)", (widgetTester) async {
    app.main();
    await widgetTester.pumpAndSettle();

    expect(image, findsNothing);
    expect(searchButton, findsOneWidget);
    await widgetTester.tap(searchButton);
    expect(image, findsNothing);
  });

  testWidgets("check Add File without selecting file", (widgetTester) async {
    app.main();
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(addFileButton);
    await wait();

    final dynamic widgetsAppState = widgetTester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();

    expect(image, findsNothing);
    expect(searchButton, findsOneWidget);
    await widgetTester.tap(searchButton);
    expect(loadingScreen, findsNothing);
  });

  testWidgets("check Add File selecting file", (widgetTester) async {
    app.main();
    await widgetTester.pumpAndSettle();

    //add file manually
    await widgetTester.tap(addFileButton);
    await wait();
    await widgetTester.pump();

    //check if image is displayed
    expect(image, findsOneWidget);
    expect(searchButton, findsOneWidget);

    //tap on search and check if loading screen is displayed
    await widgetTester.tap(searchButton);
    await widgetTester.pump();
    await wait();
    expect(loadingScreen, findsOneWidget);

    //check if WebViewScreen is displayed
    await widgetTester.pump(const Duration(seconds: 10));
    await widgetTester.pump();
    expect(goBackButton, findsOneWidget);
    expect(webViewScreen, findsOneWidget);

    //tap on goBack and check if WebViewScreen was removed and if image is displayed
    await widgetTester.tap(goBackButton);
    await widgetTester.pump(const Duration(seconds: 3));
    expect(webViewScreen, findsNothing);
    expect(goBackButton, findsNothing);
    expect(loadingScreen, findsNothing);
    expect(image, findsOneWidget);
  });
}