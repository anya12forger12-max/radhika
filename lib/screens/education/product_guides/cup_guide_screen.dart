import 'package:flutter/material.dart';

class CupGuideScreen extends StatefulWidget {
  const CupGuideScreen({super.key});

  @override
  State<CupGuideScreen> createState() => _CupGuideScreenState();
}

class _CupGuideScreenState extends State<CupGuideScreen> {
  int? _expandedSection;

  final _sections = <_GuideSection>[
    _GuideSection(
      title: 'Sizes',
      icon: Icons.straighten,
      content: '''
Choosing the right menstrual cup size is important for comfort and effectiveness. Most brands offer two sizes, typically small and large.

**Size Selection Guidelines:**

**Small Size (Usually 1-1.5 inches diameter / 25-38mm):**
- Under 30 years of age
- Never given birth vaginally
- Light to medium flow
- Active lifestyle or lower cervix
- Teens and young adults

**Large Size (Usually 1.3-1.7 inches diameter / 33-43mm):**
- 30 years or older
- Given birth vaginally
- Heavy flow
- Higher cervix
- Weaker pelvic floor muscles

**Additional Factors to Consider:**

**Cervix Height:** Your cervix sits higher during your period. Check your cervix height by inserting a clean finger during your period. If you can't reach it easily, you have a high cervix and may need a longer cup.

**Flow Volume:** If your flow is very heavy, choose a larger cup with higher capacity (30-40ml vs 15-25ml for small).

**Pelvic Floor Strength:** Weaker pelvic floor muscles may benefit from a slightly wider, shorter cup to maintain suction.

**Body Weight:** Some users find that higher body weight correlates with needing a larger cup.

**Note:** It may take 1-3 cycles to find the perfect cup for your body. Many brands offer satisfaction guarantees or starter kits with multiple sizes.
''',
    ),
    _GuideSection(
      title: 'Folding Methods',
      icon: Icons.swap_horiz,
      content: '''
Proper folding is key to comfortable insertion. Here are the most common and effective folding methods:

**C-Fold (also called U-Fold):**
Most common and easiest method. Fold the cup in half by pressing the rim together from opposite sides, creating a "C" shape. Insert with the fold facing forward or backward.

**Punch-Down Fold:**
Push one side of the rim down into the cup's opening to create a small pointed tip. This creates a smaller insertion diameter than the C-fold. Good for beginners and those with a smaller vaginal opening.

**7-Fold:**
Similar to punch-down but you push the rim down at a corner, creating a shape like the number "7" when viewed from the side. Creates a narrow, angled insertion point.

**Diamond Fold:**
Fold the cup in half, then pinch the top corners together to create a diamond shape with four layers. Very compact but can be harder to open once inside.

**Triangle Fold:**
Pinch one side of the rim to the opposite side's base, creating a triangle shape. Less common but effective for some users.

**Tips for Success:**
- Choose a fold that creates the smallest insertion diameter
- Keep the fold secure during insertion
- Release the fold once the cup is fully inserted
- Rotate the cup gently to ensure it opens fully
- Run your finger around the base to check it's fully open
''',
    ),
    _GuideSection(
      title: 'Insertion Guide',
      icon: Icons.check_circle_outline,
      content: '''
**Step 1: Prepare**
Wash your hands thoroughly with soap and water. Rinse the cup with clean water or sterilize according to manufacturer instructions.

**Step 2: Choose a Fold**
Select a folding method you're comfortable with (C-fold, punch-down, or 7-fold are recommended for beginners).

**Step 3: Get Comfortable**
Find a comfortable position:
- Sitting on the toilet with knees wide apart
- Squatting
- Standing with one leg elevated (on the toilet edge or a stool)
- Lying down

**Step 4: Fold and Insert**
- Fold the cup firmly at the rim
- Use your other hand to gently separate the labia
- Insert the folded cup into the vaginal opening, aiming toward your lower back
- Insert until the base of the cup is about 1-2 cm inside (not past your cervix)
- The stem should be just inside or slightly protruding

**Step 5: Open the Cup**
- Release your grip on the cup once it's fully inserted
- The cup should spring open
- Rotate the cup gently (360 degrees) to ensure it's fully open and create a good seal
- Run your finger around the base to check for dents or folds

**Step 6: Verify Seal**
- Gently tug on the stem or base
- You should feel resistance (suction seal)
- If the cup slides easily, it's not sealed properly
- If you feel discomfort, remove and reinsert

**Step 7: Check Comfort**
If inserted correctly, you should not feel the cup. If you feel pressure or discomfort, the cup may be:
- Too high (pressing against the cervix)
- Too low (pressing against the vaginal opening)
- Not fully open

Remove and try again if uncomfortable.
''',
    ),
    _GuideSection(
      title: 'Removal',
      icon: Icons.remove_circle_outline,
      content: '''
**Step 1: Prepare**
Wash your hands thoroughly. Get into a comfortable position (squatting or sitting on the toilet works best).

**Step 2: Locate the Stem**
Reach into the vagina and locate the stem of the cup. The stem should be just inside the vaginal opening.

**Step 3: Break the Seal**
Do NOT pull the cup by the stem alone — this can cause discomfort and may not release the suction. Instead:
- Pinch the base of the cup (not the stem) between your thumb and forefinger
- Squeeze gently to break the suction seal
- Alternatively, press the side of the cup to release the seal

**Step 4: Remove**
- Once the seal is broken, gently wiggle the cup downward
- Keep the cup upright to avoid spilling
- Remove completely and empty the contents into the toilet

**Step 5: Clean**
- Rinse the cup with clean water
- Wash with mild, unscented soap (or use the brand's recommended cleanser)
- The cup is now ready for reinsertion

**Tips:**
- If the cup feels stuck, don't panic. Relax your pelvic muscles by taking deep breaths.
- Try bearing down (as if having a bowel movement) to bring the cup lower
- If you cannot break the seal, try reaching higher and pressing on the rim directly
- With practice, removal becomes quick and easy
- Some cups have a textured stem or grip rings for easier handling
''',
    ),
    _GuideSection(
      title: 'Cleaning and Sterilization',
      icon: Icons.cleaning_services,
      content: '''
**Daily Cleaning:**
1. Empty the cup into the toilet
2. Rinse with cool water first (prevents stains)
3. Wash with warm water and mild, unscented soap
4. Rinse thoroughly to remove all soap residue
5. Dry before reinserting

**Between Periods (Storage):**
1. Sterilize the cup by boiling for 5-7 minutes
2. Allow to air dry completely
3. Store in the breathable cotton bag provided
4. Do not store in airtight containers (can promote bacterial growth)

**Boiling Instructions:**
- Place the cup in a pot of boiling water for 5-7 minutes
- Do not let the cup touch the bottom of the pot (it may melt)
- Use a dedicated pot or cup holder
- Boil at the end of each cycle

**Alternative Sterilization Methods:**
- Microwave sterilizer (if brand-approved)
- Sterilizing tablets (used for baby bottles)
- UV sterilizer devices designed for menstrual cups
- Hydrogen peroxide soak (diluted, 30 minutes)

**What NOT to Use:**
- Avoid oil-based soaps (can degrade silicone)
- No antibacterial soaps with triclosan
- No vinegar or alcohol (can damage silicone)
- No scented or moisturizing soaps
- Do not use dishwasher or microwave without special equipment

**Stain Removal:**
- Soak in 3% hydrogen peroxide for 15-30 minutes
- Rinse thoroughly after soaking
- Staining is normal and does not affect function
''',
    ),
    _GuideSection(
      title: 'Storage',
      icon: Icons.inventory_2,
      content: '''
**During Your Period:**
- Carry a small bottle of water for rinsing in public restrooms
- Use a clean, dry container when emptying outside the home
- Many cups come with a small carrying pouch
- Wet wipes can be used for cleaning in public restrooms
- Some users carry a second cup as backup

**Between Periods:**
- Always store your cup in the breathable cotton bag provided by the manufacturer
- Store in a cool, dry place away from direct sunlight
- Do not store in plastic bags or airtight containers (moisture promotes bacterial growth)
- Keep away from heat sources
- Do not store with other silicone products (they may bond together)

**Travel Tips:**
- Use the storage bag during travel
- Carry a spare cup if traveling during your period
- Bring a small collapsible cup for rinsing
- In areas with limited clean water, carry bottled water for rinsing
- Always have hand sanitizer available

**When You Have Multiple Cups:**
- Label each cup to avoid confusion
- Store separately to prevent sticking
- Track usage to know when to replace each one
''',
    ),
    _GuideSection(
      title: 'Replacement Schedule',
      icon: Icons.update,
      content: '''
**When to Replace Your Cup:**

Most menstrual cup manufacturers recommend replacing your cup every 1-2 years with proper care.

**Signs It's Time for a New Cup:**

1. **Changes in texture:** Silicone becomes sticky, tacky, or develops rough spots
2. **Discoloration:** While staining is normal, extreme discoloration may indicate degradation
3. **Cracks or tears:** Check the rim and stem for small cracks
4. **Changes in shape:** The cup no longer springs open properly
5. **Loss of suction:** The cup no longer creates a reliable seal
6. **Odor:** Persistent odor that doesn't wash out
7. **Comfort issues:** The cup has become uncomfortable to wear

**Extending Cup Life:**
- Proper cleaning after each use
- Correct storage between cycles
- Avoid using oil-based lubricants (can damage silicone)
- Boil only when needed (once per cycle is sufficient)
- Replace after any illness to prevent reinfection

**Environmental Impact:**
- One cup replaces hundreds of disposable products per year
- Over 10 years: 1 cup vs. approximately 2,400 pads or tampons
- Silicone is not biodegradable but lasts much longer than disposable alternatives
- Some brands offer recycling programs for old cups

**Remember:**
Your cup may last longer or shorter than the recommended 1-2 years depending on usage frequency and care. Always inspect your cup regularly and replace it at the first sign of wear.
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual Cup Guide'),
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
