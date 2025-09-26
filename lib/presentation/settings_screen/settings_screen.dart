import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/settings_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_switch_widget.dart';
import './widgets/settings_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Notification preferences
  bool _jobAlertsEnabled = true;
  bool _applicationUpdatesEnabled = true;
  bool _messagesEnabled = true;
  bool _marketingEnabled = false;

  // Privacy settings
  bool _profileVisibleToEmployers = true;
  bool _locationSharingEnabled = true;
  bool _dataCollectionEnabled = false;
  bool _employerContactEnabled = true;

  // App preferences
  String _selectedTheme = 'System';
  String _selectedLanguage = 'English';
  bool _accessibilityEnabled = false;
  bool _dataUsageOptimized = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: theme.iconTheme.color),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            const SettingsHeaderWidget(
              userName: 'Alex Johnson',
              userEmail: 'alex.johnson@university.edu',
              userType: 'Student',
              profileImageUrl:
                  'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100',
            ),

            const SizedBox(height: 24),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search settings...',
                prefixIcon: Icon(Icons.search,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 24),

            // Account Management Section
            if (_shouldShowSection('account'))
              SettingsSectionWidget(
                title: 'Account Management',
                icon: Icons.account_circle_outlined,
                children: [
                  SettingsTileWidget(
                    title: 'Login Credentials',
                    subtitle: 'Email: alex.johnson@university.edu',
                    leadingIcon: Icons.email_outlined,
                    onTap: () => _showLoginInfoDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Change Password',
                    subtitle: 'Last changed 3 months ago',
                    leadingIcon: Icons.lock_outline,
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Not enabled',
                    leadingIcon: Icons.security_outlined,
                    trailingWidget: Icon(
                      Icons.warning_amber_outlined,
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
                    onTap: () => _show2FADialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Linked Social Accounts',
                    subtitle: 'Google, LinkedIn connected',
                    leadingIcon: Icons.link_outlined,
                    onTap: () => _showSocialAccountsDialog(context),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Notification Preferences Section
            if (_shouldShowSection('notification'))
              SettingsSectionWidget(
                title: 'Notification Preferences',
                icon: Icons.notifications_outlined,
                children: [
                  SettingsSwitchWidget(
                    title: 'Job Alerts',
                    subtitle: 'New job opportunities matching your profile',
                    value: _jobAlertsEnabled,
                    onChanged: (value) =>
                        setState(() => _jobAlertsEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Application Updates',
                    subtitle: 'Status changes on your job applications',
                    value: _applicationUpdatesEnabled,
                    onChanged: (value) =>
                        setState(() => _applicationUpdatesEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Messages',
                    subtitle: 'New messages from employers',
                    value: _messagesEnabled,
                    onChanged: (value) =>
                        setState(() => _messagesEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Marketing Communications',
                    subtitle: 'Tips, updates, and promotional content',
                    value: _marketingEnabled,
                    onChanged: (value) =>
                        setState(() => _marketingEnabled = value),
                  ),
                  SettingsTileWidget(
                    title: 'Custom Notification Schedule',
                    subtitle: 'Set quiet hours and frequency',
                    leadingIcon: Icons.schedule_outlined,
                    onTap: () => _showNotificationScheduleDialog(context),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Privacy Settings Section
            if (_shouldShowSection('privacy'))
              SettingsSectionWidget(
                title: 'Privacy Settings',
                icon: Icons.privacy_tip_outlined,
                children: [
                  SettingsSwitchWidget(
                    title: 'Profile Visible to Employers',
                    subtitle: 'Allow employers to find your profile',
                    value: _profileVisibleToEmployers,
                    onChanged: (value) =>
                        setState(() => _profileVisibleToEmployers = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Location Sharing',
                    subtitle: 'Show your location for nearby jobs',
                    value: _locationSharingEnabled,
                    onChanged: (value) =>
                        setState(() => _locationSharingEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Data Collection for Analytics',
                    subtitle: 'Help improve our services',
                    value: _dataCollectionEnabled,
                    onChanged: (value) =>
                        setState(() => _dataCollectionEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Allow Employer Contact',
                    subtitle: 'Let employers message you directly',
                    value: _employerContactEnabled,
                    onChanged: (value) =>
                        setState(() => _employerContactEnabled = value),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // App Preferences Section
            if (_shouldShowSection('app') ||
                _shouldShowSection('theme') ||
                _shouldShowSection('language'))
              SettingsSectionWidget(
                title: 'App Preferences',
                icon: Icons.settings_outlined,
                children: [
                  SettingsTileWidget(
                    title: 'Theme',
                    subtitle: _selectedTheme,
                    leadingIcon: Icons.palette_outlined,
                    onTap: () => _showThemeDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Language',
                    subtitle: _selectedLanguage,
                    leadingIcon: Icons.language_outlined,
                    onTap: () => _showLanguageDialog(context),
                  ),
                  SettingsSwitchWidget(
                    title: 'Accessibility Features',
                    subtitle: 'Enhanced text size and contrast',
                    value: _accessibilityEnabled,
                    onChanged: (value) =>
                        setState(() => _accessibilityEnabled = value),
                  ),
                  SettingsSwitchWidget(
                    title: 'Optimize Data Usage',
                    subtitle: 'Reduce mobile data consumption',
                    value: _dataUsageOptimized,
                    onChanged: (value) =>
                        setState(() => _dataUsageOptimized = value),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Security Section
            if (_shouldShowSection('security') || _shouldShowSection('login'))
              SettingsSectionWidget(
                title: 'Security',
                icon: Icons.shield_outlined,
                children: [
                  SettingsTileWidget(
                    title: 'Login History',
                    subtitle: 'View recent login activity',
                    leadingIcon: Icons.history_outlined,
                    onTap: () => _showLoginHistoryDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Active Sessions',
                    subtitle: '3 active devices',
                    leadingIcon: Icons.devices_outlined,
                    onTap: () => _showActiveSessionsDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Account Deletion',
                    subtitle: 'Permanently delete your account',
                    leadingIcon: Icons.delete_forever_outlined,
                    trailingWidget: Icon(
                      Icons.warning_outlined,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    onTap: () => _showAccountDeletionDialog(context),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Support Section
            if (_shouldShowSection('support'))
              SettingsSectionWidget(
                title: 'Support',
                icon: Icons.support_agent_outlined,
                children: [
                  SettingsTileWidget(
                    title: 'FAQ & Help Center',
                    subtitle: 'Find answers to common questions',
                    leadingIcon: Icons.help_center_outlined,
                    onTap: () => _showFAQDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Contact Support',
                    subtitle: 'Get help from our team',
                    leadingIcon: Icons.contact_support_outlined,
                    onTap: () => _showContactSupportDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Live Chat',
                    subtitle: 'Available 9 AM - 6 PM EST',
                    leadingIcon: Icons.chat_bubble_outline,
                    trailingWidget: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Online',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () => _showLiveChatDialog(context),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Backup & Sync Section
            if (_shouldShowSection('backup') || _shouldShowSection('sync'))
              SettingsSectionWidget(
                title: 'Backup & Sync',
                icon: Icons.cloud_sync_outlined,
                children: [
                  SettingsTileWidget(
                    title: 'Data Backup',
                    subtitle: 'Last backup: Today, 2:30 PM',
                    leadingIcon: Icons.backup_outlined,
                    onTap: () => _showBackupDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Sync Across Devices',
                    subtitle: 'Keep your data synchronized',
                    leadingIcon: Icons.sync_outlined,
                    onTap: () => _showSyncDialog(context),
                  ),
                  SettingsTileWidget(
                    title: 'Cloud Storage Preferences',
                    subtitle: 'Manage storage settings',
                    leadingIcon: Icons.cloud_outlined,
                    onTap: () => _showCloudStorageDialog(context),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSignOutDialog(context),
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  bool _shouldShowSection(String searchTerm) {
    if (_searchQuery.isEmpty) return true;
    return searchTerm.contains(_searchQuery);
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help'),
        content: const Text(
            'Need help? Visit our Help Center or contact support for assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoginInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: alex.johnson@university.edu',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Account Type: Student',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Member since: January 2024',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Last login: Today, 10:30 AM',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showChangePasswordDialog(context);
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _show2FADialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text(
            'Enable two-factor authentication to add an extra layer of security to your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        '2FA setup initiated. Check your email for instructions.')),
              );
            },
            child: const Text('Enable 2FA'),
          ),
        ],
      ),
    );
  }

  void _showSocialAccountsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Linked Social Accounts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('Google'),
              subtitle: const Text('Connected'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Disconnect'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.blue),
              title: const Text('LinkedIn'),
              subtitle: const Text('Connected'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Disconnect'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Schedule'),
        content: const Text(
            'Set your preferred notification times and quiet hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'Light',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'Dark',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('System'),
              value: 'System',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('French'),
              value: 'French',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Today, 10:30 AM'),
              subtitle: const Text('Mobile App - iPhone'),
              leading: const Icon(Icons.phone_iphone),
            ),
            ListTile(
              title: const Text('Yesterday, 2:15 PM'),
              subtitle: const Text('Web Browser - Chrome'),
              leading: const Icon(Icons.computer),
            ),
            ListTile(
              title: const Text('Dec 10, 8:45 AM'),
              subtitle: const Text('Mobile App - iPhone'),
              leading: const Icon(Icons.phone_iphone),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('iPhone 15 Pro'),
              subtitle: const Text('Current device'),
              leading: const Icon(Icons.phone_iphone),
              trailing: const Text('Active'),
            ),
            ListTile(
              title: const Text('MacBook Pro'),
              subtitle: const Text('Last used: 2 hours ago'),
              leading: const Icon(Icons.laptop_mac),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('End'),
              ),
            ),
            ListTile(
              title: const Text('Chrome Browser'),
              subtitle: const Text('Last used: Yesterday'),
              leading: const Icon(Icons.computer),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('End'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAccountDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FAQ & Help Center'),
        content: const Text(
            'Access our comprehensive help center with tutorials, guides, and frequently asked questions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Visit Help Center'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Support request submitted. We\'ll get back to you soon!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text(
            'Connect with our support team for real-time assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Backup'),
        content: const Text(
            'Your data is automatically backed up to secure cloud storage. You can also manually create a backup.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Manual backup initiated...')),
              );
            },
            child: const Text('Backup Now'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Across Devices'),
        content: const Text(
            'Keep your profile, applications, and preferences synchronized across all your devices.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }

  void _showCloudStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cloud Storage Preferences'),
        content: const Text(
            'Manage how your data is stored and synchronized in the cloud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to login/splash screen
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.splash, (route) => false);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
