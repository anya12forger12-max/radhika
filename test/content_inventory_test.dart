import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Content inventory and quality guards for Radhika's educational content.
///
/// These tests verify that all education topics have required fields and
/// that the content structure is complete. They do NOT verify medical accuracy
/// (that requires qualified clinical review).
void main() {
  group('Education content inventory', () {
    // The education screen defines topics as a list of _EducationTopic objects.
    // We verify the source file contains the expected structure.
    test('education_screen.dart contains required topics', () {
      final content = File('lib/screens/education/education_screen.dart')
          .readAsStringSync();
      expect(content, contains("title: 'Understanding Menstruation'"),
          reason: 'Core menstruation topic must exist');
      expect(content, contains("title: 'Menstrual Pads'"),
          reason: 'Pads topic must exist');
      expect(content, contains("title: 'Tampons'"),
          reason: 'Tampons topic must exist');
      expect(content, contains("title: 'Menstrual Cups'"),
          reason: 'Cups topic must exist');
      expect(content, contains("title: 'Health & Wellness'"),
          reason: 'Health & Wellness topic must exist');
      expect(content, contains("title: 'Pain Management'"),
          reason: 'Pain Management topic must exist');
    });

    test('education content includes medical disclaimers', () {
      final content = File('lib/screens/education/education_screen.dart')
          .readAsStringSync();
      expect(content, contains('consult a healthcare provider'),
          reason: 'Medical disclaimer must be present');
    });

    test('product guides include "When to See a Doctor" sections', () {
      for (final guide in [
        'lib/screens/education/product_guides/pad_guide_screen.dart',
        'lib/screens/education/product_guides/tampon_guide_screen.dart',
        'lib/screens/education/product_guides/cup_guide_screen.dart',
      ]) {
        final content = File(guide).readAsStringSync();
        final lower = content.toLowerCase();
      final hasMedicalGuidance = lower.contains('seek medical') ||
          lower.contains('see a doctor') ||
          lower.contains('medical assistance') ||
          lower.contains('medical attention') ||
          lower.contains('consult a healthcare provider');
      expect(hasMedicalGuidance, isTrue,
          reason: '$guide must include medical escalation guidance');
      }
    });

    test('product guides include educational-purpose disclaimer', () {
      for (final guide in [
        'lib/screens/education/product_guides/pad_guide_screen.dart',
        'lib/screens/education/product_guides/tampon_guide_screen.dart',
        'lib/screens/education/product_guides/cup_guide_screen.dart',
      ]) {
        final content = File(guide).readAsStringSync();
        expect(content, contains('educational purposes only'),
            reason: '$guide must include educational disclaimer');
      }
    });

    test('tampon guide includes TSS awareness', () {
      final content =
          File('lib/screens/education/product_guides/tampon_guide_screen.dart')
              .readAsStringSync();
      expect(content, contains('TSS'),
          reason: 'Tampon guide must mention Toxic Shock Syndrome');
    });

    test('pain management includes red-flag symptoms', () {
      final content = File('lib/screens/education/education_screen.dart')
          .readAsStringSync();
      expect(content, contains('Heavy bleeding'),
          reason: 'Pain management must list heavy bleeding as red flag');
      expect(content, contains('fever'),
          reason: 'Pain management must list fever as red flag');
    });
  });
}
