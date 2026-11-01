import 'package:flutter/material.dart';
import 'package:radhika/core/constants/app_constants.dart';

/// Learning path progression for different user needs.
/// From Section 7.3 of the Master Prompt.
enum LearningPath {
  firstPeriod('First-Period Path'),
  menstrualHygiene('Menstrual Hygiene Path'),
  menstrualHealth('Menstrual Health Path'),
  reproductiveHealth('Reproductive Health Path'),
  vaginalHealth('Vaginal Health Path');

  final String displayName;
  const LearningPath(this.displayName);

  static LearningPath fromString(String value) {
    return LearningPath.values.firstWhere(
      (e) => e.displayName == value,
      orElse: () => firstPeriod,
    );
  }
}

class _EducationTopic {
  final String title;
  final IconData icon;
  final String summary;
  final String? content;
  final bool onTap;
  final Widget? destinationScreen;
  final LearningPath? learningPath;
  final bool hasKnowledgeCheck;
  final String? category;
  final String? topic;

  _EducationTopic({
    required this.title,
    required this.icon,
    required this.summary,
    this.content,
    this.onTap = false,
    this.destinationScreen,
    this.learningPath,
    this.hasKnowledgeCheck = false,
    this.category,
    this.topic,
  });
}

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  int? _expandedIndex;

  final _topics = <_EducationTopic>[
    _EducationTopic(
      title: 'Understanding Menstruation',
      icon: Icons.loop,
      content: '''
Menstruation is the monthly shedding of the uterine lining (endometrium) that occurs as part of the menstrual cycle. This natural biological process typically begins between ages 11 and 14 and continues until menopause, usually around age 45-55.

**The Menstrual Cycle Phases:**

1. **Menstrual Phase (Days 1-5):** The uterine lining sheds, resulting in menstrual bleeding. This is what we commonly refer to as a "period." Bleeding typically lasts 3-7 days.

2. **Follicular Phase (Days 1-13):** The pituitary gland releases follicle-stimulating hormone (FSH), which stimulates the ovaries to produce follicles. Each follicle contains an egg. Usually, only one follicle matures fully.

3. **Ovulation (Around Day 14):** A surge in luteinizing hormone (LH) triggers the release of a mature egg from the ovary. The egg travels through the fallopian tube, where it may be fertilized.

4. **Luteal Phase (Days 15-28):** After ovulation, the empty follicle transforms into the corpus luteum, which produces progesterone. This hormone prepares the uterine lining for potential pregnancy. If pregnancy doesn't occur, hormone levels drop and the cycle begins anew.

**Key Hormones Involved:**
- Estrogen: Builds the uterine lining
- Progesterone: Maintains the uterine lining
- FSH: Stimulates follicle growth
- LH: Triggers ovulation

The average cycle length is 28 days, but cycles ranging from 21 to 35 days are considered normal for adults. Teenagers may have cycles ranging from 21 to 45 days as their bodies mature.
''',
      summary: 'Menstruation is the monthly shedding of the uterine lining that occurs as part of the menstrual cycle. This natural biological process typically begins between ages 11 and 14 and continues until menopause, usually around age 45-55. The average cycle length is 28 days, but cycles ranging from 21 to 35 days are considered normal for adults.',
      onTap: false,
      destinationScreen: null,
      learningPath: null,
      hasKnowledgeCheck: false,
      category: 'menstruation',
      topic: 'menstruation',
    ),
    _EducationTopic(
      title: 'Menstrual Flow',
      icon: Icons.graphic_eq,
      summary: 'Menstrual flow varies significantly from person to person and even from cycle to cycle. Flow is often described using qualitative terms rather than exact measurements. These categories are educational guides, not medical diagnoses.',
      category: 'flow',
      topic: 'flow',
    ),
    _EducationTopic(
      title: 'Menstrual Product Education',
      icon: Icons.inventory,
      summary: 'This section provides educational information about common menstrual products. Product suitability is individual - what works well for one person may not work for another. No single product is best for everyone.',
      category: 'products',
      topic: 'product_education',
    ),
    _EducationTopic(
      title: 'Flow-to-Product Comparison',
      icon: Icons.compare_arrows,
      summary: 'This comparison table is an educational guide to help you think about product options based on flow description. It is not a universal prescription. Product selection must remain flexible and preference-based.',
      category: 'products',
      topic: 'flow_product_comparison',
    ),
    _EducationTopic(
      title: 'When Products Need Changing',
      icon: Icons.timer,
      summary: 'Changing frequency depends on product type, flow, saturation, leakage, comfort, and manufacturer guidance. Here are safety principles.',
      category: 'products',
      topic: 'product_timing',
    ),
    _EducationTopic(
      title: 'Menstrual Hygiene',
      icon: Icons.clean_hands,
      summary: 'Practical menstrual hygiene information: before and after changing products, wash hands thoroughly with soap and water. Cleaning reusable products, disposal of disposable products, recognizing irritation or allergic reactions, and general hygiene practices.',
      category: 'hygiene',
      topic: 'hygiene',
    ),
    _EducationTopic(
      title: 'Health Warnings and When to Seek Help',
      icon: Icons.medical_services,
      summary: 'Users should consult a healthcare professional when menstrual bleeding is repeatedly much heavier than their usual pattern, or when bleeding lasts longer than usual or more than about seven days, or when menstrual bleeding interferes substantially with everyday activities.',
      category: 'care',
      topic: 'seek_care',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual Health Education'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _topics.length + 1,
        itemBuilder: (context, index) {
          if (index == _topics.length) {
            return _DisclaimerCard();
          }
          final topic = _topics[index];
          final isExpanded = _expandedIndex == index;

          return Semantics(
            label: topic.title,
            hint: topic.onTap ? 'Tap to view ${topic.title} details' : null,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (topic.onTap && topic.destinationScreen != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => topic.destinationScreen!,
                          ),
                        );
                      } else {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            topic.icon,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              topic.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (topic.onTap)
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (topic.learningPath != null) ...[
                                  Tooltip(
                                    message: 'Learning path: ${topic.learningPath!.displayName}',
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      child: Icon(
                                        Icons.terrain,
                                        size: 14,
                                        color: Color(0xFFFFC10D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                if (topic.hasKnowledgeCheck)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Icon(
                                      Icons.quiz,
                                      size: 14,
                                      color: Color(0xFFFFC10D),
                                    ),
                                  ),
                              ],
                            ),
                          const Spacer(),
                          const SizedBox(width: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Medical disclaimer',
      child: Card(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppConstants.medicalDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}