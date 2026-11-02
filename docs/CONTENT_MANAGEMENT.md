# Radhika — Content Management and Governance

## A. Existing Content Architecture

### Storage
- **Static bundled Dart files** — all educational content is compiled into the APK
- No CMS, no database-backed content, no remote content API
- Content is versioned with the app (every content change requires an APK rebuild + new release)

### Content Files
| File | Content | Size |
|---|---|---|
| `lib/screens/education/education_screen.dart` | 6 topics: Menstruation, Pads, Tampons, Cups, Health & Wellness, Pain Management | 364 lines |
| `lib/screens/education/product_guides/pad_guide_screen.dart` | 7 sections: Types, Choosing, Wearing, Changing, Disposal, Hygiene, Environment | 414 lines |
| `lib/screens/education/product_guides/tampon_guide_screen.dart` | 7 sections: Types, Absorbency, Insertion, Removal, Frequency, TSS, Hygiene | 456 lines |
| `lib/screens/education/product_guides/cup_guide_screen.dart` | 7 sections: Sizes, Folding, Insertion, Removal, Cleaning, Storage, Replacement | 465 lines |
| `lib/screens/education/recommendations_screen.dart` | Personalized symptom-based tips | 352 lines |

### Content Inventory

#### Menstrual Health Fundamentals
| ID | Title | Status | Source | Review |
|---|---|---|---|---|
| edu-001 | Understanding Menstruation | Published | Standard medical knowledge | Pending clinical review |
| edu-002 | Health & Wellness | Published | Standard nutrition/exercise guidance | Pending clinical review |
| edu-003 | Pain Management | Published | Standard medical knowledge | Pending clinical review |

#### Menstrual Hygiene Products
| ID | Title | Status | Source | Review |
|---|---|---|---|---|
| edu-004 | Menstrual Pads (guide) | Published | Product manufacturer guidelines | Pending clinical review |
| edu-005 | Tampons (guide) | Published | Product manufacturer guidelines + TSS awareness | Pending clinical review |
| edu-006 | Menstrual Cups (guide) | Published | Product manufacturer guidelines | Pending clinical review |

#### Symptom Information
- Included within Pain Management topic (cramps, dysmenorrhea, endometriosis, fibroids, PCOS, PID, adenomyosis)
- Recommendations screen provides symptom-specific tips

#### Food and Hydration
- Included within Health & Wellness topic (iron-rich foods, calcium, magnesium, hydration, gentle exercise, stress management)

#### Safety and Medical Guidance
- "When to See a Doctor" sections in Pain Management and product guides
- TSS awareness in tampon guide
- "Always consult a healthcare provider" disclaimers on all topics

### Content Metadata
- **No version metadata** on individual content items
- **No source references** (no URLs, citations, or DOIs)
- **No review dates** or next-review dates
- **No content owner** or author tracking
- **No revision history**
- Content is versioned only at the APK level (pubspec version)

### Content Lifecycle
```
DRAFT (in source code)
  ↓
CODE REVIEW (git PR)
  ↓
APK BUILD (CI pipeline)
  ↓
GITHUB RELEASE (v* tag)
  ↓
USER DOWNLOADS APK
```

No separate content review or medical approval workflow exists.

### Content Quality Checks
- `flutter analyze` checks code quality, not content accuracy
- No automated content validation (missing titles, broken references, etc.)
- No spell-check or readability checks in CI

### Limitations
1. **No remote content updates**: Every content change requires an APK rebuild and new release
2. **No CMS**: Content is hardcoded in Dart source files
3. **No medical review tracking**: No reviewer credentials, dates, or approval status
4. **No source citations**: Medical claims lack traceable references
5. **No localization**: Only English content
6. **No content search**: Users browse topics manually
7. **No version history**: Git provides code history but no content-specific versioning

### Recommendations
1. **Add source references** to medical claims (WHO, CDC, ACOG guidelines)
2. **Add content metadata** (last reviewed date, reviewer, next review date) as Dart constants
3. **Implement content validation tests** (missing titles, empty content, broken references)
4. **Consider remote content** (JSON from Firebase Remote Config) for critical safety updates without APK rebuild
5. **Add content search** within the education screen
6. **Implement localization** (i18n) for non-English users
7. **Establish medical review process** with qualified healthcare professional

### Automated Content Test (Created)
See `test/content_inventory_test.dart` — verifies all education topics have non-empty titles and content, all product guides have required sections, and no topic is missing a disclaimer.

---

## B. Content Inventory Summary

| Category | Topics | Status |
|---|---|---|
| Menstrual fundamentals | 1 (Understanding Menstruation) | Published, unreviewed |
| Product guides | 3 (Pads, Tampons, Cups) | Published, unreviewed |
| Health & Wellness | 1 | Published, unreviewed |
| Pain Management | 1 | Published, unreviewed |
| Recommendations | Dynamic (symptom-based) | Published, unreviewed |

**Total**: 6 static topics + dynamic recommendations
**Medical review status**: 0 of 6 topics have qualified clinical review
**Source references**: 0 of 6 topics have traceable citations
