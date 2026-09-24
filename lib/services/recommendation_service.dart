import 'package:radhika/models/cycle_entry.dart';

/// A single piece of symptom-based guidance shown on the Recommendations
/// screen. [iconKey] is a stable lookup key the UI maps to an icon; keeping it
/// here (instead of an IconData) keeps the service free of Flutter imports.
class Recommendation {
  const Recommendation({
    required this.title,
    required this.iconKey,
    required this.reliefTips,
    required this.dietTips,
    this.symptom,
    this.careNote,
  });

  final String title;
  final String iconKey;
  final List<String> reliefTips;
  final List<String> dietTips;

  /// The [Symptom] this recommendation targets, or null for general cards.
  final Symptom? symptom;

  /// Short note to surface when a symptom may warrant professional care.
  final String? careNote;

  bool get isGeneral => symptom == null;
}

/// Builds personalized relief and diet guidance from a user's logged cycle
/// entries, considering only entries within [windowDays] for freshness.
class RecommendationService {
  RecommendationService({this._windowDays = defaultWindowDays});

  static const int defaultWindowDays = 30;

  final int _windowDays;

  List<Recommendation> build({required List<CycleEntry> entries}) {
    final cutoff = DateTime.now().subtract(Duration(days: _windowDays));
    final recent =
        entries.where((e) => !e.startDate.isBefore(cutoff)).toList();

    final symptomDays = <Symptom, int>{};
    var maxPain = 0;
    var heavyFlowDays = 0;
    for (final entry in recent) {
      for (final symptom in entry.symptoms) {
        symptomDays[symptom] = (symptomDays[symptom] ?? 0) + 1;
      }
      if (entry.painLevel > maxPain) maxPain = entry.painLevel;
      if (entry.flowIntensity == FlowIntensity.heavy ||
          entry.flowIntensity == FlowIntensity.veryHeavy ||
          entry.spotting) {
        heavyFlowDays++;
      }
    }

    final result = <Recommendation>[];

    final hasPainSymptom =
        symptomDays.containsKey(Symptom.cramps) ||
            symptomDays.containsKey(Symptom.backPain);
    if (maxPain >= 4 && !hasPainSymptom) {
      result.add(_severePain);
    }

    for (final symptom in _orderedSymptoms) {
      if (!symptomDays.containsKey(symptom)) continue;
      result.add(_adviceFor(symptom));
    }

    if (heavyFlowDays > 0) {
      result.add(_heavyFlowSupport);
    }

    if (result.isEmpty) {
      return const [_generalWellness];
    }
    return result;
  }

  static const List<Symptom> _orderedSymptoms = [
    Symptom.cramps,
    Symptom.backPain,
    Symptom.headache,
    Symptom.nausea,
    Symptom.bloating,
    Symptom.breastTenderness,
    Symptom.fatigue,
    Symptom.acne,
    Symptom.moodSwings,
    Symptom.anxiety,
    Symptom.depression,
  ];

  Recommendation _adviceFor(Symptom symptom) => _advice[symptom]!;

  static const Map<Symptom, Recommendation> _advice = {
    Symptom.cramps: Recommendation(
      title: 'Cramps',
      iconKey: 'cramps',
      symptom: Symptom.cramps,
      reliefTips: [
        'Apply heat to your lower abdomen with a heating pad or hot water bottle',
        'Try gentle exercise like walking, stretching, or yoga (child\'s pose, cat-cow)',
        'Take a warm bath or shower to relax the pelvic muscles',
        'Rest and avoid heavy lifting when pain is strong',
        'Over-the-counter pain relievers (e.g. ibuprofen) taken as directed can help',
      ],
      dietTips: [
        'Add anti-inflammatory foods: turmeric, ginger, berries, leafy greens, fatty fish',
        'Get enough calcium from dairy, fortified plant milk, or almonds',
        'Magnesium-rich foods (dark chocolate, nuts, bananas) may ease cramping',
        'Cut back on salt and caffeine and stay well hydrated',
      ],
      careNote:
          'If cramps are severe, last beyond your period, or don\'t respond to '
          'over-the-counter relief, talk to a healthcare provider.',
    ),
    Symptom.backPain: Recommendation(
      title: 'Back Pain',
      iconKey: 'back_pain',
      symptom: Symptom.backPain,
      reliefTips: [
        'Apply heat to your lower back to help relax tight muscles',
        'Try gentle stretches like knee-to-chest and child\'s pose',
        'Keep light movement such as walking through the day',
        'Support your lower back when sitting and sleep with a pillow between your knees',
      ],
      dietTips: [
        'Include anti-inflammatory foods and omega-3s (fatty fish, walnuts, flax seeds)',
        'Stay hydrated to keep tissues and muscles comfortable',
        'Limit processed foods and excess caffeine',
      ],
      careNote:
          'If back pain is severe, persistent, or comes with other symptoms, '
          'consult a healthcare provider.',
    ),
    Symptom.headache: Recommendation(
      title: 'Headache',
      iconKey: 'headache',
      symptom: Symptom.headache,
      reliefTips: [
        'Drink water - dehydration is a common headache trigger',
        'Rest in a quiet, dimly lit room',
        'Place a cool cloth on your forehead or the back of your neck',
        'Gently massage your neck and shoulders',
        'Keep a steady sleep and meal schedule around your cycle',
      ],
      dietTips: [
        'Eat regular meals to avoid blood sugar dips',
        'Magnesium-rich foods (dark chocolate, nuts, whole grains) may help',
        'Limit caffeine and alcohol, which can make headaches worse',
        'Don\'t skip meals, especially on low-energy days',
      ],
      careNote:
          'Frequent or severe headaches, or headaches with vision changes, '
          'warrant a healthcare provider review.',
    ),
    Symptom.nausea: Recommendation(
      title: 'Nausea',
      iconKey: 'nausea',
      symptom: Symptom.nausea,
      reliefTips: [
        'Eat small, frequent meals instead of large ones',
        'Sip ginger tea or chew a small piece of ginger',
        'Peppermint tea can help settle your stomach',
        'Get fresh air and avoid strong cooking smells',
        'Sit upright or recline gently after eating',
      ],
      dietTips: [
        'Choose bland foods: crackers, toast, bananas, rice, plain yogurt',
        'Avoid greasy, spicy, or very rich foods',
        'Stay hydrated with small, frequent sips of water',
        'Keep eating regularly even if your appetite is low',
      ],
      careNote:
          'If nausea is severe, causes vomiting, or is new and unexplained, '
          'seek medical advice.',
    ),
    Symptom.bloating: Recommendation(
      title: 'Bloating',
      iconKey: 'bloating',
      symptom: Symptom.bloating,
      reliefTips: [
        'Take a short walk to support digestion',
        'Apply gentle warmth to your abdomen',
        'Try light yoga or stretching for the lower belly',
        'Limit carbonated drinks and chewing gum',
      ],
      dietTips: [
        'Potassium-rich foods (banana, avocado, leafy greens) help counter bloat',
        'Drink plenty of water and avoid excess salty, processed foods',
        'Ginger or peppermint tea may ease a bloated feeling',
        'Introduce fiber gradually if it\'s new to your routine',
      ],
    ),
    Symptom.breastTenderness: Recommendation(
      title: 'Breast Tenderness',
      iconKey: 'breast_tenderness',
      symptom: Symptom.breastTenderness,
      reliefTips: [
        'Wear a supportive, well-fitted bra (a soft sleep bra at night)',
        'Apply a warm or cool compress for comfort',
        'Reduce caffeine, which can increase tenderness',
        'Try gentle massage or light stretching',
      ],
      dietTips: [
        'Reduce salt and processed foods',
        'Magnesium and vitamin B6-rich foods (bananas, nuts, lean poultry)',
        'Include fatty fish and flax seeds in a supportive diet',
        'Limit high-saturated-fat foods',
      ],
      careNote:
          'A new lump, persistent one-sided tenderness, or unusual discharge '
          'should be checked by a healthcare provider.',
    ),
    Symptom.fatigue: Recommendation(
      title: 'Fatigue',
      iconKey: 'fatigue',
      symptom: Symptom.fatigue,
      reliefTips: [
        'Prioritize 7-9 hours of sleep, especially in the days before your period',
        'Take short rest breaks and avoid over-scheduling',
        'Gentle movement like walking can boost energy',
        'Keep consistent sleep and wake times',
      ],
      dietTips: [
        'Iron-rich foods (leafy greens, beans, lentils, lean meat) support energy, especially during heavy flow',
        'Pair iron-rich meals with vitamin C (citrus, bell peppers) to help absorption',
        'Choose complex carbs and protein for steady energy (oats, whole grains, eggs)',
        'Stay hydrated throughout the day',
      ],
      careNote:
          'If fatigue persists despite rest and a balanced diet, a healthcare '
          'provider can check for causes such as low iron.',
    ),
    Symptom.acne: Recommendation(
      title: 'Acne',
      iconKey: 'acne',
      symptom: Symptom.acne,
      reliefTips: [
        'Use a gentle, non-comedogenic cleanser twice daily',
        'Avoid picking or squeezing blemishes',
        'Change pillowcases regularly and keep hair off your face',
        'Manage stress and stick to your usual sleep routine',
      ],
      dietTips: [
        'Limit refined sugars and high-glycemic foods that may flare acne',
        'Zinc-rich foods (pumpkin seeds, chickpeas, lentils) support skin',
        'Stay hydrated and eat plenty of vegetables',
        'Include probiotic-rich foods like plain yogurt',
      ],
      careNote:
          'Persistent or severe acne may improve with a planned skincare '
          'routine guided by a dermatologist.',
    ),
    Symptom.moodSwings: Recommendation(
      title: 'Mood Swings',
      iconKey: 'mood_swings',
      symptom: Symptom.moodSwings,
      reliefTips: [
        'Acknowledge mood shifts as a normal part of the cycle; try not to judge yourself',
        'Step away briefly and take slow, deep breaths when emotions spike',
        'Keep a journal to spot patterns across your cycle',
        'Gentle exercise and fresh air help lift mood',
        'Prioritize sleep - mood is tightly linked to rest',
      ],
      dietTips: [
        'Complex carbs (oats, whole grains) support steady energy and mood',
        'Include omega-3s from fatty fish, walnuts, or flax seeds',
        'Magnesium-rich foods (nuts, dark chocolate, leafy greens)',
        'Limit caffeine, sugar spikes, and alcohol',
      ],
      careNote:
          'If mood swings are intense, frequent, or interfere with daily life, '
          'speak with a healthcare provider.',
    ),
    Symptom.anxiety: Recommendation(
      title: 'Anxiety',
      iconKey: 'anxiety',
      symptom: Symptom.anxiety,
      reliefTips: [
        'Try slow breathing (in for 4 counts, out for 6) during anxious moments',
        'Limit caffeine, which can intensify feelings of nervousness',
        'Keep a consistent sleep schedule',
        'Break tasks into small steps and spend time outdoors',
        'Talk to someone you trust about how you\'re feeling',
      ],
      dietTips: [
        'Steady your blood sugar with balanced meals (protein plus complex carbs)',
        'Omega-3s (fatty fish, chia seeds, walnuts) may support mood',
        'Magnesium-rich foods and calm herbal teas can be relaxing choices',
        'Reduce alcohol and late-day caffeine',
      ],
      careNote:
          'If anxiety persists, feels overwhelming, or affects daily life, '
          'reaching out to a healthcare provider or counselor can help.',
    ),
    Symptom.depression: Recommendation(
      title: 'Depression',
      iconKey: 'depression',
      symptom: Symptom.depression,
      reliefTips: [
        'Be gentle with yourself - low mood around your cycle is common',
        'Keep small routines: a short walk, sunlight, and connecting with someone',
        'Journaling can help untangle thoughts and spot patterns',
        'Prioritize sleep and try not to isolate when you can',
        'Consider talking to a counselor or healthcare provider',
      ],
      dietTips: [
        'Balanced meals with complex carbs and protein to steady energy',
        'Omega-3s (fatty fish, walnuts, flax seeds)',
        'B vitamins from whole grains, eggs, and leafy greens',
        'Stay hydrated and limit alcohol',
      ],
      careNote:
          'If low mood lasts more than two weeks, or you have thoughts of '
          'self-harm, reach out for help right away - a trusted person, a '
          'crisis line, or emergency services.',
    ),
  };

  static const Recommendation _severePain = Recommendation(
    title: 'Severe Pain Care',
    iconKey: 'severe_pain',
    reliefTips: [
      'Rest and apply heat to the painful area (abdomen or lower back)',
      'Consider over-the-counter pain relief taken exactly as directed',
      'Gentle stretching may help, but avoid intense activity',
      'Track when pain peaks so you can notice patterns',
    ],
    dietTips: [
      'Anti-inflammatory foods and plenty of water',
      'Limit salt and caffeine',
      'Don\'t skip meals - stable blood sugar supports comfort',
    ],
    careNote:
        'Severe pain (4-5 out of 5) that repeats, or pain with heavy bleeding, '
        'fever, or vomiting, needs evaluation by a healthcare provider.',
  );

  static const Recommendation _heavyFlowSupport = Recommendation(
    title: 'Heavy Flow Support',
    iconKey: 'heavy_flow',
    reliefTips: [
      'Track your flow so you can spot unusually heavy cycles',
      'Rest when energy is very low and keep up light movement',
      'Change products regularly and keep extras on hand',
      'Spotting days count too - note them for more accurate tracking',
    ],
    dietTips: [
      'Iron-rich foods (leafy greens, beans, lentils, lean red meat)',
      'Pair with vitamin C (citrus, bell peppers) to help iron absorption',
      'Stay hydrated and include whole grains for steady energy',
    ],
    careNote:
        'If you soak through a pad or tampon every hour, pass large clots, or '
        'bleeding lasts beyond 7 days, see a healthcare provider.',
  );

  static const Recommendation _generalWellness = Recommendation(
    title: 'Healthy Cycle Habits',
    iconKey: 'general',
    reliefTips: [
      'Track symptoms and moods daily so your insights improve over time',
      'Keep moving gently - walks, yoga, or stretching support comfort',
      'Sleep 7-9 hours and keep a steady routine',
      'Manage stress with deep breathing, warm baths, or journaling',
    ],
    dietTips: [
      'Stay hydrated and limit salty, processed foods around your cycle',
      'Eat iron-rich foods during bleeding (leafy greens, beans, lentils)',
      'Include calcium and magnesium sources daily (dairy, nuts, leafy greens)',
      'Add anti-inflammatory foods like ginger, turmeric, berries, and fatty fish',
    ],
  );
}