import 'package:hive/hive.dart';

part 'app_preferences.g.dart';

/// Central user preference model for personalization.
///
/// All preferences are stored as JSON in the user's Hive settings box.
/// Preferences are optional — the app degrades gracefully when a user
/// declines personalization or has no saved preferences.
@HiveType(typeId: 18)
class AppPreferences extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String languageCode;
  @HiveField(2)
  bool personalizationEnabled;
  @HiveField(3)
  List<String> preferredTopics;
  @HiveField(4)
  List<String> preferredContentFormats;
  @HiveField(5)
  double accessibilityFontSize;
  @HiveField(6)
  bool highContrastMode;
  @HiveField(7)
  List<String> accessibilityFeatures;

  AppPreferences({
    required this.id,
    this.languageCode = 'en',
    this.personalizationEnabled = true,
    List<String>? preferredTopics,
    List<String>? preferredContentFormats,
    this.accessibilityFontSize = 1.0,
    this.highContrastMode = false,
    List<String>? accessibilityFeatures,
  })  : preferredTopics = preferredTopics ?? ['menstrual_health', 'hygiene_products', 'symptom_education', 'food_hydration', 'general_wellness', 'faqs', 'medical_guidance'],
        preferredContentFormats = preferredContentFormats ?? ['articles', 'guides', 'videos', 'faqs'],
        accessibilityFeatures = accessibilityFeatures ?? ['screen_reader', 'large_text', 'high_contrast'];

  /// Whether a specific topic is preferred
  bool getPreferredTopic(String topic) => preferredTopics.contains(topic);

  /// Whether a specific content format is preferred
  bool getPreferredFormat(String format) => preferredContentFormats.contains(format);

  /// Whether a specific accessibility feature is enabled
  bool getAccessibilityFeature(String feature) => accessibilityFeatures.contains(feature);

  AppPreferences copyWith({
    String? languageCode,
    bool? personalizationEnabled,
    List<String>? preferredTopics,
    List<String>? preferredContentFormats,
    double? accessibilityFontSize,
    bool? highContrastMode,
    List<String>? accessibilityFeatures,
  }) {
    return AppPreferences(
      id: id,
      languageCode: languageCode ?? this.languageCode,
      personalizationEnabled: personalizationEnabled ?? this.personalizationEnabled,
      preferredTopics:
          preferredTopics ?? this.preferredTopics,
      preferredContentFormats:
          preferredContentFormats ?? this.preferredContentFormats,
      accessibilityFontSize: accessibilityFontSize ?? this.accessibilityFontSize,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      accessibilityFeatures: accessibilityFeatures ?? this.accessibilityFeatures,
    );
  }
}