import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Adaptive banner ad shown at the bottom of the home screen.
///
/// Uses the real AdMob banner unit for radhika.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  // AdMob banner unit for radhika (com.radhika.app).
  static const String adUnitId = 'ca-app-pub-7692188087567714/5141301526';

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('Failed to initialize MobileAds: $e');
      if (mounted) {
        setState(() => _loaded = false);
      }
      return;
    }

    final adapter = BannerAd(
      adUnitId: AdBanner.adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _banner = ad as BannerAd;
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() => _loaded = false);
          }
        },
        onAdImpression: (_) {},
        onAdClicked: (_) {},
      ),
    );

    try {
      await adapter.load();
    } catch (e) {
      debugPrint('Failed to load banner ad: $e');
      if (mounted) {
        setState(() => _loaded = false);
      }
    }
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _banner == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        child: AdWidget(ad: _banner!),
      ),
    );
  }
}