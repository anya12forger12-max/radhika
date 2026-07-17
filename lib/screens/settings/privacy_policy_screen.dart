import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/providers/auth_provider.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  final bool isRequired;

  const PrivacyPolicyScreen({
    super.key,
    this.isRequired = false,
  });

  @override
  ConsumerState<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        actions: [
          if (!widget.isRequired)
            Semantics(
              label: 'Close privacy policy',
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildPolicyText(theme, colorScheme),
            ),
          ),
          if (widget.isRequired) ...[
            const Divider(height: 1),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: 'I have read and agree to the Privacy Policy checkbox',
                      child: CheckboxListTile(
                        title: const Text(
                          'I have read and agree to the Privacy Policy',
                        ),
                        value: _accepted,
                        onChanged: (v) => setState(() => _accepted = v ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Semantics(
                      label: _accepted
                          ? 'Accept and continue button'
                          : 'Accept and continue button disabled',
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _accepted
                              ? () async {
                                  await ref.read(authProvider.notifier).acceptPrivacyPolicy();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          child: const Text('Accept & Continue'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPolicyText(ThemeData theme, ColorScheme colorScheme) {
    final sections = AppConstants.privacyPolicyText.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        final trimmed = section.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();

        if (RegExp(r'^\d+\.').hasMatch(trimmed)) {
          final lines = trimmed.split('\n');
          final header = lines.first;
          final content = lines.skip(1).join('\n').trim();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (content.contains('\n- ')) ...[
                  const SizedBox(height: 4),
                  ...content.split('\n').where((l) => l.trim().startsWith('-')).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        item.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        if (trimmed == trimmed.toUpperCase() && trimmed.length > 3) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              trimmed,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            trimmed,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }
}
