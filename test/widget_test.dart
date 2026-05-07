import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leco_feedback_app/main.dart';

void main() {
  testWidgets('renders stacked feedback kiosk and submits selected rating', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1180, 800));
    await tester.pumpWidget(const LecoFeedbackApp());
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('LECO'), findsOneWidget);
    expect(find.text('How did we\ndo today?'), findsOneWidget);
    expect(find.text('Okay'), findsOneWidget);

    final submit = find.text('Submit');
    expect(submit, findsOneWidget);

    await tester.tap(find.text('Very good'));
    await tester.pumpAndSettle();

    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Submit'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Thank you!'), findsOneWidget);
    expect(find.text('Queue ID: Q-247'), findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
