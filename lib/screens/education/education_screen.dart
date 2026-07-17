import 'package:flutter/material.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/screens/education/product_guides/cup_guide_screen.dart';
import 'package:radhika/screens/education/product_guides/pad_guide_screen.dart';
import 'package:radhika/screens/education/product_guides/tampon_guide_screen.dart';

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
      icon: Icons.cycle,
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
    ),
    _EducationTopic(
      title: 'Menstrual Pads',
      icon: Icons.checkroom,
      content:
          'For detailed information about menstrual pads, including types, usage instructions, hygiene tips, and environmental considerations, view the complete guide.',
      onTap: true,
      destinationScreen: const PadGuideScreen(),
    ),
    _EducationTopic(
      title: 'Tampons',
      icon: Icons.medical_services_outlined,
      content:
          'For detailed information about tampons, including absorbency types, insertion guide, removal, and TSS awareness, view the complete guide.',
      onTap: true,
      destinationScreen: const TamponGuideScreen(),
    ),
    _EducationTopic(
      title: 'Menstrual Cups',
      icon: Icons.water_drop,
      content:
          'For detailed information about menstrual cups, including sizes, folding methods, insertion, removal, and cleaning, view the complete guide.',
      onTap: true,
      destinationScreen: const CupGuideScreen(),
    ),
    _EducationTopic(
      title: 'Health & Wellness',
      icon: Icons.spa,
      content: '''
**Nutrition During Your Cycle:**

**Iron-Rich Foods:** During menstruation, iron levels can drop. Include leafy greens, beans, lentils, lean red meat, and fortified cereals in your diet.

**Calcium Sources:** May help reduce menstrual cramps. Good sources include dairy products, fortified plant milks, leafy greens, and almonds.

**Magnesium:** Can help reduce bloating and mood symptoms. Find it in dark chocolate, nuts, seeds, and whole grains.

**Hydration:** Drink plenty of water throughout your cycle. Proper hydration can reduce bloating and help with headaches and fatigue.

**Gentle Exercise:**
- Walking: 20-30 minutes of walking can improve blood flow and reduce cramps
- Yoga: Certain poses like child's pose, cat-cow, and reclining bound angle pose can ease discomfort
- Swimming: The buoyancy can relieve pressure on the abdomen
- Stretching: Gentle stretching helps maintain flexibility and reduce muscle tension

**Stress Management:**
- Deep breathing exercises (4-7-8 technique)
- Meditation or mindfulness practice (even 5-10 minutes daily)
- Adequate sleep (7-9 hours per night)
- Warm baths with Epsom salts
- Journaling to track mood and symptoms

**When to Rest:** Listen to your body. If fatigue or pain is significant, prioritize rest and gentle self-care over vigorous activity.
''',
    ),
    _EducationTopic(
      title: 'Pain Management',
      icon: Icons.healing,
      content: '''
**Understanding Menstrual Pain:**

Dysmenorrhea (menstrual cramps) is caused by prostaglandins, chemicals that make the uterus contract to shed its lining. These contractions can cause pain and inflammation.

**Heat Therapy:**
- Apply a heating pad or hot water bottle to the lower abdomen
- Take a warm bath with Epsom salts
- Use heat patches designed for menstrual relief
- Benefits: Heat relaxes uterine muscles and improves blood flow

**Gentle Exercise:**
- Light walking to improve circulation
- Gentle yoga stretches targeting the pelvic area
- Swimming for full-body relaxation
- Avoid high-intensity exercise during severe pain

**Over-the-Counter Relief:**
- Ibuprofen (Advil, Motrin): Reduces prostaglandins, making cramps less intense
- Naproxen (Aleve): Longer-lasting pain relief
- Always follow dosage instructions and consult a healthcare provider

**Dietary Approaches:**
- Reduce salt intake to minimize bloating
- Limit caffeine which can increase tension
- Anti-inflammatory foods: turmeric, ginger, berries, fatty fish
- Herbal teas: chamomile, ginger, peppermint

**When to See a Doctor:**

Seek medical advice if you experience:
- Pain that interferes significantly with daily activities
- Pain that doesn't respond to over-the-counter medication
- Heavy bleeding (soaking through a pad or tampon every hour)
- Periods that last longer than 7 days
- Bleeding between periods
- Sudden changes in your menstrual pattern
- Severe pain accompanied by nausea, vomiting, or fever

**Possible Underlying Conditions:**
- Endometriosis
- Uterine fibroids
- Pelvic inflammatory disease
- Adenomyosis
- Polycystic ovary syndrome (PCOS)

Always consult a healthcare provider for persistent or severe symptoms.
''',
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
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (topic.onTap && topic.destinationScreen != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
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
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.expand_more,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!topic.onTap)
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: _TopicContent(content: topic.content),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
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

class _TopicContent extends StatelessWidget {
  final String content;
  const _TopicContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = content.trim().split('\n');
    final children = <InlineSpan>[];

    for (final line in lines) {
      if (line.startsWith('**') && line.endsWith('**')) {
        children.add(TextSpan(
          text: line.replaceAll('**', ''),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ));
        children.add(const TextSpan(text: '\n\n'));
      } else if (line.startsWith('- ')) {
        children.add(TextSpan(
          text: '\u2022 ${line.substring(2)}',
          style: theme.textTheme.bodyMedium,
        ));
        children.add(const TextSpan(text: '\n'));
      } else if (line.startsWith('**')) {
        final parts = line.split('**');
        for (var i = 0; i < parts.length; i++) {
          if (parts[i].isNotEmpty) {
            children.add(TextSpan(
              text: parts[i],
              style: i % 2 == 1
                  ? theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                  : theme.textTheme.bodyMedium,
            ));
          }
        }
        children.add(const TextSpan(text: '\n'));
      } else if (line.trim().isEmpty) {
        children.add(const TextSpan(text: '\n'));
      } else {
        children.add(TextSpan(
          text: line,
          style: theme.textTheme.bodyMedium,
        ));
        children.add(const TextSpan(text: '\n'));
      }
    }

    return Semantics(
      label: 'Educational content',
      child: RichText(
        text: TextSpan(children: children),
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

class _EducationTopic {
  final String title;
  final IconData icon;
  final String content;
  final bool onTap;
  final Widget? destinationScreen;

  _EducationTopic({
    required this.title,
    required this.icon,
    required this.content,
    this.onTap = false,
    this.destinationScreen,
  });
}
