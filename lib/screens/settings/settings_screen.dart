import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/theme_provider.dart';
import 'package:radhika/screens/settings/privacy_policy_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool _reminder3Days = true;
  bool _reminder2Days = true;
  bool _reminder1Day = true;
  bool _reminderToday = true;

  Future<void> _exportData() async {
    final authState = ref.read(authProvider);
    final user = authState.user.value;
    if (user == null) return;

    final storageService = ref.read(storageServiceProvider);
    final json = await storageService.exportData(user.uid);
    await Share.share(json, subject: 'Radhika Data Export');
  }

  Future<void> _deleteAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This will permanently delete all your cycle data, predictions, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final authState = ref.read(authProvider);
      final user = authState.user.value;
      if (user != null) {
        final storageService = ref.read(storageServiceProvider);
        await storageService.clearUserData(user.uid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All data deleted')),
          );
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).deleteAccount();
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (time != null) {
      setState(() => _notificationTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Appearance'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Theme selector',
                    child: SegmentedButton<ThemeModeSetting>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeModeSetting.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeModeSetting.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode),
                        ),
                        ButtonSegment(
                          value: ThemeModeSetting.system,
                          label: Text('System'),
                          icon: Icon(Icons.settings_brightness),
                        ),
                      ],
                      selected: {themeState.setting},
                      onSelectionChanged: (selected) {
                        ref.read(themeProvider.notifier).setThemeMode(selected.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    label: 'Font size slider',
                    child: Row(
                      children: [
                        const Icon(Icons.text_fields, size: 20),
                        Expanded(
                          child: Slider(
                            value: themeState.fontSize,
                            min: 0.8,
                            max: 1.5,
                            divisions: 7,
                            label: '${(themeState.fontSize * 100).round()}%',
                            onChanged: (value) {
                              ref.read(themeProvider.notifier).setFontSize(value);
                            },
                          ),
                        ),
                        const Icon(Icons.text_fields, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Notifications'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Semantics(
                    label: 'Remind me 3 days before period toggle',
                    child: SwitchListTile(
                      title: const Text('3 days before'),
                      value: _reminder3Days,
                      onChanged: (v) => setState(() => _reminder3Days = v),
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Remind me 2 days before period toggle',
                    child: SwitchListTile(
                      title: const Text('2 days before'),
                      value: _reminder2Days,
                      onChanged: (v) => setState(() => _reminder2Days = v),
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Remind me 1 day before period toggle',
                    child: SwitchListTile(
                      title: const Text('1 day before'),
                      value: _reminder1Day,
                      onChanged: (v) => setState(() => _reminder1Day = v),
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Remind me on period start day toggle',
                    child: SwitchListTile(
                      title: const Text('Day of period'),
                      value: _reminderToday,
                      onChanged: (v) => setState(() => _reminderToday = v),
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: 'Notification time picker',
                    child: ListTile(
                      title: const Text('Notification time'),
                      trailing: Text(
                        _notificationTime.format(context),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Data'),
          Card(
            child: Column(
              children: [
                Semantics(
                  label: 'Export data button',
                  child: ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: const Text('Export Data'),
                    subtitle: const Text('Share your data as JSON'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportData,
                  ),
                ),
                const Divider(height: 1),
                Semantics(
                  label: 'Delete all data button',
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep_outlined, color: colorScheme.error),
                    title: Text('Delete All Data', style: TextStyle(color: colorScheme.error)),
                    subtitle: const Text('Remove all local data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _deleteAllData,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Account'),
          Card(
            child: Column(
              children: [
                Semantics(
                  label: 'Privacy Policy button',
                  child: ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(isRequired: false),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Semantics(
                  label: 'Delete account button',
                  child: ListTile(
                    leading: Icon(Icons.person_remove_outlined, color: colorScheme.error),
                    title: Text('Delete Account', style: TextStyle(color: colorScheme.error)),
                    subtitle: const Text('Permanently remove your account'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _deleteAccount,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(title: 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Name'),
                  trailing: const Text(AppConstants.appName),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tag),
                  title: const Text('Version'),
                  trailing: const Text(AppConstants.appVersion),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Semantics(
            label: 'Logout button',
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Logout'),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
