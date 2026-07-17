import 'package:flutter/material.dart';

class PadGuideScreen extends StatefulWidget {
  const PadGuideScreen({super.key});

  @override
  State<PadGuideScreen> createState() => _PadGuideScreenState();
}

class _PadGuideScreenState extends State<PadGuideScreen> {
  int? _expandedSection;

  final _sections = <_GuideSection>[
    _GuideSection(
      title: 'Types of Pads',
      icon: Icons.category,
      content: '''
**Disposable Pads:**
Single-use pads made with absorbent materials like wood pulp, super absorbent polymer (SAP), and a waterproof backing. Available in various sizes and absorbencies for different flow levels. Convenient for on-the-go use.

**Reusable Cloth Pads:**
Made from absorbent fabrics like cotton, bamboo, or hemp. These are washable and can last 2-5 years with proper care. They come with snap closures to secure around underwear. Environmentally friendly and cost-effective long-term.

**Pantyliners:**
Thin, lightweight pads designed for very light flow days, spotting, or daily freshness. Less absorbent than regular pads. Good for use at the beginning or end of your period.

**Overnight Pads:**
Extra-long and wider pads designed for overnight use. They provide additional coverage and absorbency for up to 8 hours of sleep. Most have extended back coverage and wings for secure placement.

**Maternity Pads:**
Specifically designed for postpartum bleeding (lochia). Extra thick and soft, with higher absorbency than regular pads. They are longer and wider to accommodate healing after childbirth.

**Organic/Bamboo Pads:**
Made from organic cotton or bamboo fibers, free from chlorine bleaching, fragrances, and synthetic materials. A good choice for sensitive skin and those wanting to reduce chemical exposure.
''',
    ),
    _GuideSection(
      title: 'Choosing the Right Pad',
      icon: Icons.search,
      content: '''
**Consider Your Flow:**

- **Light flow:** Pantyliners or thin pads with light absorbency (1-2 drops on packaging)
- **Medium flow:** Regular pads with moderate absorbency (3 drops)
- **Heavy flow:** Super or maxi pads (4-5 drops)
- **Very heavy/overnight:** Overnight pads or ultra-thick pads (5+ drops)

**Consider Your Lifestyle:**
- **Active lifestyle:** Look for ultra-thin pads with good absorbency and wing closures
- **Long work/school days:** Choose higher absorbency and consider changing during breaks
- **Sleeping:** Overnight pads with extended length for back-lying coverage
- **Swimming:** Pads are not suitable for swimming; consider tampons or menstrual cups

**Consider Sensitivity:**
- Choose unscented, dye-free options if you have sensitive skin
- Organic cotton topsheets can reduce irritation
- Avoid pads with plastic backing if you experience heat or discomfort

**Size and Shape:**
- Wings help secure the pad and prevent leaks
- Contoured shapes fit the body better
- Longer pads offer more coverage, especially for sleeping
''',
    ),
    _GuideSection(
      title: 'How to Wear a Pad',
      icon: Icons.check_circle_outline,
      content: '''
**Step 1: Prepare**
Wash your hands thoroughly with soap and water before handling a new pad.

**Step 2: Unwrap**
Remove the pad from its individual wrapper. Dispose of the wrapper properly.

**Step 3: Remove Backing**
Peel off the paper backing from the adhesive strip on the back of the pad.

**Step 4: Position**
Place the pad sticky-side down in the center of your underwear. The wider end typically goes toward the back for better coverage. Make sure the pad is centered and flat.

**Step 5: Secure Wings**
If your pad has wings, wrap them around the edges of your underwear and press firmly to secure them in place. Wings help prevent leaks and keep the pad stable.

**Step 6: Adjust**
Ensure the pad lies flat against your body. Adjust if there are any wrinkles or bunching that could cause leaks.

**Step 7: Change Regularly**
Change your pad every 4-6 hours, or more frequently if needed. Never leave a pad on for more than 8 hours.
''',
    ),
    _GuideSection(
      title: 'How Often to Change',
      icon: Icons.timer_outlined,
      content: '''
**General Guideline: Change every 4-6 hours**

- **Light flow days:** Every 4-6 hours
- **Medium flow days:** Every 3-4 hours
- **Heavy flow days:** Every 2-3 hours or sooner if needed
- **Overnight:** Before sleeping and immediately upon waking

**Signs You Need to Change Sooner:**
- Feeling of wetness or saturation
- Visible blood on the pad surface
- Unpleasant odor developing
- Discomfort or skin irritation

**Why Frequent Changing Matters:**
- Prevents bacterial growth and reduces infection risk
- Prevents leaks and staining
- Reduces skin irritation and rashes
- Maintains comfort and freshness
- Reduces risk of toxic shock syndrome (though risk is much lower with pads than tampons)

**Never wear a pad for more than 8 hours**, even on light flow days.
''',
    ),
    _GuideSection(
      title: 'Safe Disposal',
      icon: Icons.delete_outline,
      content: '''
**Do Not Flush:**
Menstrual pads should NEVER be flushed down the toilet. They cause blockages in plumbing and sewage systems, leading to costly repairs and environmental damage.

**Proper Disposal Steps:**

1. **Roll or fold** the used pad with the absorbent side inward
2. **Wrap** it in the original wrapper, toilet paper, or a disposal bag
3. **Place** in a waste bin (preferably a lidded bin)
4. **Wash hands** thoroughly after disposal

**Disposal Options:**
- Regular trash bin (most common)
- Feminine hygiene disposal units in public restrooms
- Biodegradable disposal bags for environmental consideration
- Some communities have special sanitary waste collection

**Environmental Note:**
Disposable pads contribute significantly to landfill waste. Each pad can take 500-800 years to decompose. Consider reusable alternatives to reduce environmental impact.
''',
    ),
    _GuideSection(
      title: 'Hygiene Tips',
      icon: Icons.clean_hands,
      content: '''
**Before Use:**
- Always wash hands before handling a new pad
- Store pads in a clean, dry place
- Check expiration dates (pads do expire and may lose absorbency)

**During Use:**
- Change pads every 4-6 hours minimum
- Wash hands before and after changing
- Avoid using scented pads if you have sensitive skin
- If skin irritation occurs, try unscented or organic cotton pads

**After Use:**
- Dispose of used pads properly (do not flush)
- Clean the genital area gently with warm water and mild soap
- Pat dry thoroughly before applying a new pad
- Wear clean, breathable cotton underwear

**Skin Care:**
- Prolonged pad use can cause heat rash or irritation
- Allow your skin to "breathe" by using pads without plastic backing
- Change pads more frequently during hot weather
- Consider alternating with other products like menstrual cups

**When to See a Doctor:**
- Persistent itching, burning, or rash in the genital area
- Unusual discharge or odor
- Signs of allergic reaction to pad materials
''',
    ),
    _GuideSection(
      title: 'Environmental Considerations',
      icon: Icons.eco,
      content: '''
**Impact of Disposable Pads:**
- A single disposable pad contains the equivalent of about 4 plastic bags
- The average menstruator uses approximately 11,000 disposable pads in a lifetime
- Disposable pads take 500-800 years to decompose in landfills
- Most pads contain non-biodegradable plastics and super absorbent polymers

**Eco-Friendly Alternatives:**

**Reusable Cloth Pads:**
- Washable and reusable for 2-5 years
- Made from natural fibers like organic cotton, bamboo, or hemp
- Reduce waste significantly
- Cost-effective over time

**Period Underwear:**
- Absorbent underwear designed to replace pads
- Can be washed and reused
- Available in different absorbency levels
- Discreet and comfortable

**Menstrual Cups:**
- Reusable for 1-2 years
- Zero daily waste
- Made from medical-grade silicone
- Most environmentally friendly option

**Tips to Reduce Environmental Impact:**
- Consider switching to reusable products
- When using disposables, choose brands with biodegradable components
- Look for plastic-free and compostable options
- Support brands with sustainable packaging and practices
- Spread awareness about menstrual product waste
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual Pads Guide'),
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
