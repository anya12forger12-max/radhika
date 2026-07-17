import 'package:flutter/material.dart';

class TamponGuideScreen extends StatefulWidget {
  const TamponGuideScreen({super.key});

  @override
  State<TamponGuideScreen> createState() => _TamponGuideScreenState();
}

class _TamponGuideScreenState extends State<TamponGuideScreen> {
  int? _expandedSection;

  final _sections = <_GuideSection>[
    _GuideSection(
      title: 'Types of Tampons',
      icon: Icons.category,
      content: '''
**Applicator Tampons:**
These tampons come with a plastic or cardboard applicator that helps guide the tampon into place. The applicator has an outer tube and an inner plunger. Push the plunger to release the tampon into the vaginal canal, then discard the applicator.

- **Plastic applicators:** Smooth, easy insertion; less environmentally friendly
- **Cardboard applicators:** Biodegradable, but may be less comfortable for insertion

**Non-Applicator (Digital) Tampons:**
These tampons are inserted using your finger only, without an applicator. They are typically smaller to carry and produce less waste. Insertion requires more direct contact but offers more control over placement.

- More compact for carrying
- Less waste
- Usually more affordable
- Require good hand hygiene

**Absorbency Levels:**
Tampons come in different absorbency ratings standardized by the FDA:

- **Junior/Light:** For very light flow days (6g or less)
- **Regular:** For moderate flow (6-9g)
- **Super:** For heavier flow (9-12g)
- **Super Plus:** For very heavy flow (12-15g)
- **Ultra:** For extremely heavy flow (15-18g)

Always use the lowest absorbency needed for your flow to reduce the risk of Toxic Shock Syndrome (TSS).
''',
    ),
    _GuideSection(
      title: 'Choosing the Right Absorbency',
      icon: Icons.search,
      content: '''
**Match Absorbency to Your Flow:**

- **Light/Spotting:** Junior or Light absorbency
- **Light to Medium:** Regular absorbency
- **Medium to Heavy:** Super absorbency
- **Heavy:** Super Plus absorbency
- **Very Heavy:** Ultra absorbency

**Important Guidelines:**

- Use the lowest absorbency tampon that meets your needs
- If a tampon is uncomfortable to remove or feels dry, switch to a lower absorbency
- If you need to change a Super Plus tampon in less than 2 hours, the absorbency is appropriate but you may need to see a doctor about heavy bleeding
- It's normal to need different absorbencies on different days of your period
- Consider using pads overnight for longer wear and lower TSS risk

**Changing Absorbency Throughout Your Cycle:**
- Days 1-2 (heavier): Super or Super Plus
- Days 3-4 (moderate): Regular or Super
- Days 5-7 (lighting): Junior or Light
- End of period: Pantyliners may suffice

**When Not to Use Tampons:**
- Between periods (unless for discharge, and even then, limit use)
- Immediately after childbirth (consult your doctor)
- If you have a history of TSS
- If you have vaginal infections
- If you have undergone recent gynecological surgery
''',
    ),
    _GuideSection(
      title: 'Insertion Guide',
      icon: Icons.check_circle_outline,
      content: '''
**Step 1: Prepare**
Wash your hands thoroughly with soap and water. Unwrap the tampon. If using an applicator tampon, hold it between your thumb and middle finger at the grip area.

**Step 2: Get Comfortable**
Find a comfortable position:
- Sitting on the toilet with knees apart
- Standing with one leg elevated on the toilet seat
- Squatting slightly
- Lying down

**Step 3: Insert (Applicator Tampon)**
- Hold the applicator at the grip (where the outer tube meets the plunger)
- Use your other hand to gently separate the labia
- Insert the applicator tip into the vaginal opening, aiming toward your lower back (not straight up)
- Insert until your fingers touch your body
- Push the inner plunger all the way in to release the tampon
- Remove the applicator (both tubes together)
- The string should hang outside your body

**Step 4: Insert (Non-Applicator Tampon)**
- Hold the tampon between your thumb and middle finger at the indentation
- Use your other hand to gently separate the labia
- Insert the tampon into the vaginal opening, aiming toward your lower back
- Push until your fingers touch your body and the tampon is fully inside
- The string should hang outside your body

**Step 5: Verify**
If inserted correctly, you should not feel the tampon. If you feel discomfort, it may not be inserted far enough. Remove and try again with a fresh tampon.

**Common Mistakes:**
- Not inserting far enough (tampon should sit past the pubococcygeus muscle)
- Inserting at the wrong angle (aim toward lower back, not straight up)
- Not relaxing pelvic muscles (take deep breaths)
''',
    ),
    _GuideSection(
      title: 'Proper Removal',
      icon: Icons.remove_circle_outline,
      content: '''
**Step 1: Prepare**
Wash your hands. Get into a comfortable position similar to insertion.

**Step 2: Locate the String**
Gently pull on the string that hangs outside your body.

**Step 3: Remove**
Pull the string downward and forward at a slight angle. The tampon should slide out easily. If you feel resistance, the tampon may not be fully saturated. If it's completely dry, consider using a lower absorbency next time.

**Step 4: Dispose**
Wrap the used tampon in toilet paper or its wrapper. Place it in a waste bin. Do NOT flush tampons down the toilet as they can cause plumbing blockages.

**Step 5: Clean**
Wash your hands thoroughly with soap and water.

**Tips:**
- If you cannot find the string, use clean fingers to gently explore the vaginal canal
- If the string is inside, bear down (as if having a bowel movement) to help bring the tampon lower
- If you still cannot remove it, seek medical assistance
- After removal, a new tampon can be inserted immediately

**What to Do If You Forget to Remove a Tampon:**
- If forgotten for more than 8 hours, try to remove it as soon as you remember
- If you have difficulty removing it or notice unusual odor, discharge, or fever, seek medical attention promptly
- Wearing a tampon too long increases the risk of TSS
''',
    ),
    _GuideSection(
      title: 'Changing Frequency',
      icon: Icons.timer_outlined,
      content: '''
**General Guideline: Change every 4-8 hours**

- **Light flow:** Every 6-8 hours
- **Moderate flow:** Every 4-6 hours
- **Heavy flow:** Every 2-4 hours

**Critical Rule: Never wear a tampon for more than 8 hours**

Set a reminder on your phone if needed. Change your tampon just before bed and immediately upon waking.

**Know Your Flow:**
- If a tampon is saturated in less than 2 hours, this may indicate heavy menstrual bleeding (menorrhagia). Consult your healthcare provider.
- If a tampon feels dry or uncomfortable to remove after 4 hours, switch to a lower absorbency.

**Overnight Considerations:**
- Insert a fresh tampon right before sleep
- Set an alarm to change it during the night if your flow is heavy
- Consider using overnight pads instead for worry-free sleep
- Maximum 8 hours regardless of absorbency

**Tracking:**
- Keep track of how many tampons you use per day
- Average use: 3-6 tampons per day
- This information is helpful to share with your healthcare provider
''',
    ),
    _GuideSection(
      title: 'TSS Awareness',
      icon: Icons.warning_amber,
      content: '''
**What is Toxic Shock Syndrome (TSS)?**

TSS is a rare but serious bacterial infection caused by Staphylococcus aureus or Streptococcus pyogenes bacteria. It is associated with tampon use, particularly when tampons are left in for too long or when high-absorbency tampons are used.

**Symptoms of TSS:**
- Sudden high fever (102F / 39C or higher)
- Low blood pressure (feeling faint or dizzy)
- Sunburn-like rash, especially on palms and soles
- Redness of eyes, mouth, and throat
- Muscle aches
- Headache
- Confusion
- Vomiting or diarrhea
- Peeling skin on hands and feet (in later stages)

**If you experience any of these symptoms while using tampons, remove the tampon immediately and seek emergency medical care.**

**TSS Prevention:**

1. **Use the lowest absorbency** tampon for your flow
2. **Change tampons every 4-8 hours**
3. **Never wear a tampon for more than 8 hours**
4. **Wash hands** before and after insertion/removal
5. **Alternate with pads** especially at night
6. **Do not use tampons** if you have a history of TSS
7. **Do not use tampons** between periods

**Risk Factors:**
- Leaving a tampon in too long
- Using high-absorbency tampons
- Using tampons between periods
- Having a history of TSS
- Having skin infections or wounds
- Recent childbirth or surgery

**TSS is treatable when caught early**, but requires immediate medical attention with antibiotics and supportive care. The risk of TSS is approximately 1 in 100,000 for menstruators using tampons.
''',
    ),
    _GuideSection(
      title: 'Hygiene Practices',
      icon: Icons.clean_hands,
      content: '''
**Before Insertion:**
- Wash hands thoroughly with soap and water
- Ensure tampons are stored in a clean, dry place
- Check packaging for damage before use
- Do not use expired tampons

**During Use:**
- Change tampons regularly (every 4-8 hours)
- Use unscented tampons (scented ones may cause irritation)
- Avoid touching the tampon surface before insertion
- If you drop a tampon on the floor, discard it and use a fresh one

**After Removal:**
- Dispose of tampons in a waste bin (never flush)
- Wash hands thoroughly
- Clean the genital area gently with warm water
- Pat dry before inserting a new tampon
- Allow time for air circulation by using pads occasionally

**General Vaginal Health:**
- The vagina is self-cleaning; avoid douching or using vaginal hygiene products
- Wear breathable cotton underwear
- Avoid wearing tampons when you don't have your period
- If you notice unusual discharge, odor, itching, or irritation, stop using tampons and consult a healthcare provider

**Travel Tips:**
- Carry spare tampons in a clean pouch or case
- Store tampons away from heat and moisture
- When using public restrooms, ensure you have hand sanitizer if soap is unavailable
- Always dispose of used tampons properly in sanitary bins
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tampon Guide'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _sections.length + 1,
        itemBuilder: (context, index) {
          if (index == _sections.length) {
            return _MedicalDisclaimer();
          }
          final section = _sections[index];
          final isExpanded = _expandedSection == index;

          return Semantics(
            label: section.title,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedSection = isExpanded ? null : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            section.icon,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              section.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _SectionContent(content: section.content),
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

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = content.trim().split('\n');
    final children = <InlineSpan>[];

    for (final line in lines) {
      if (line.startsWith('**') && line.endsWith('**')) {
        children.add(TextSpan(
          text: '${line.replaceAll('**', '')}\n',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (line.startsWith('- ')) {
        children.add(TextSpan(
          text: '\u2022 ${line.substring(2)}\n',
          style: theme.textTheme.bodyMedium,
        ));
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
          text: '$line\n',
          style: theme.textTheme.bodyMedium,
        ));
      }
    }

    return Semantics(
      label: 'Section content',
      child: RichText(
        text: TextSpan(children: children),
      ),
    );
  }
}

class _MedicalDisclaimer extends StatelessWidget {
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
                  'This information is for educational purposes only. Always consult a healthcare provider for medical advice.',
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

class _GuideSection {
  final String title;
  final IconData icon;
  final String content;

  _GuideSection({
    required this.title,
    required this.icon,
    required this.content,
  });
}
