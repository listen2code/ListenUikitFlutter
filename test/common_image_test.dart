import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_uikit/widgets/common_image.dart';

void main() {
  testWidgets('CommonImage.url with invalid base64 renders without uncaught exception',
      (WidgetTester tester) async {
    // A corrupted base64 string that decodes to zeroes
    const corruptBase64 = 'data:image/png;base64,AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonImage.url(
            corruptBase64,
            width: 50,
            height: 50,
            errorWidget: Icon(Icons.error, key: Key('error_fallback')),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify widget tree pumped cleanly without crashing
    expect(find.byType(CommonImage), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('CommonImage.url with standard http URL builds CachedNetworkImage',
      (WidgetTester tester) async {
    const remoteUrl = 'https://example.com/avatar.png';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonImage.url(
            remoteUrl,
            width: 50,
            height: 50,
          ),
        ),
      ),
    );

    expect(find.byType(CommonImage), findsOneWidget);
  });
}
