import 'package:flutter/material.dart';
import 'package:e_learning/core/localization/bloc/locale_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning/core/design_system/theme_extension/app_theme_extension.dart';
import 'package:e_learning/core/design_system/theme_extension/theme_manager.dart';
import 'package:e_learning/core/localization/localization.dart';

import 'package:e_learning/core/notifications/models/push_notification_model.dart';
import 'package:e_learning/core/notifications/notification_handler.dart';

class FlutterBunnyScreen extends StatefulWidget {
  const FlutterBunnyScreen({Key? key}) : super(key: key);

  @override
  State<FlutterBunnyScreen> createState() => _FlutterBunnyScreenState();
}

class _FlutterBunnyScreenState extends State<FlutterBunnyScreen> {
  String? fcmToken;
  bool notificationsEnabled = true;
  bool isTokenExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
  }

  Future<void> _loadFCMToken() async {
    try {
      final token = await notificationHandler.getFCMToken();
      if (mounted) {
        setState(() {
          fcmToken = token;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          fcmToken = 'Not available';
          notificationsEnabled = false;
        });
      }
    }
  }

  void _sendTestNotification() async {
    final notification = PushNotificationModel(
      title: 'Test Notification',
      body: 'This is a test notification from your app',
      payload: '{"type": "test", "id": "123"}',
    );

    await notificationHandler.showLocalNotification(notification);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.notificationSent),
        backgroundColor: context.theme.colors.activeButton,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.surface,
      appBar: AppBar(
        title: Text(
          'E Learning',
          style: context.theme.fonts.headerLarger.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              return TextButton.icon(
                onPressed: _showLanguagePicker,
                icon: Text(
                  Localization.getLanguageFlag(state.locale.languageCode),
                  style: const TextStyle(fontSize: 20),
                ),
                label: const Icon(Icons.arrow_drop_down, size: 20),
                style: TextButton.styleFrom(
                  foregroundColor: context.theme.colors.textPrimary,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              _buildThemeSection(),

              const SizedBox(height: 30),

              // Notification Section
              _buildNotificationSection(),

              const SizedBox(height: 30),

              // Language Section
              BlocBuilder<LocaleBloc, LocaleState>(
                builder: (context, state) {
                  return _buildLanguageSection(state.locale);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.palette_outlined,
              color: context.theme.colors.activeButton,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.theme,
              style: context.theme.fonts.headerLarger.copyWith(
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildThemeModeButton(
                  ThemeModeEnum.light,
                  Icons.light_mode,
                  context.l10n.lightMode,
                ),
                const SizedBox(width: 12),
                _buildThemeModeButton(
                  ThemeModeEnum.dark,
                  Icons.dark_mode,
                  context.l10n.darkMode,
                ),
                const SizedBox(width: 12),
                _buildThemeModeButton(
                  ThemeModeEnum.system,
                  Icons.brightness_auto,
                  context.l10n.systemMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeButton(
      ThemeModeEnum mode, IconData icon, String label) {
    final isSelected = context.watch<ThemeCubit>().state.themeMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ThemeCubit>().setTheme(mode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? context.theme.colors.activeButton
                : context.theme.colors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.theme.colors.activeButton.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? context.theme.colors.textWhite
                    : context.theme.colors.textPrimary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? context.theme.colors.textWhite
                      : context.theme.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              color: context.theme.colors.activeButton,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.notifications,
              style: context.theme.fonts.headerLarger.copyWith(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  context.l10n.enableNotifications,
                  style: context.theme.fonts.headerSmall,
                ),
                subtitle: Text(
                  context.l10n.receiveNotifications,
                  style: context.theme.fonts.subHeader,
                ),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
                activeColor: context.theme.colors.activeButton,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),

              const Divider(height: 1),

              // Test notification button
              ListTile(
                leading: Icon(
                  Icons.send_outlined,
                  color: context.theme.colors.iconBlue,
                ),
                title: Text(
                  context.l10n.sendTestNotification,
                  style: context.theme.fonts.headerSmall,
                ),
                onTap: _sendTestNotification,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),

              // FCM token (collapsible)
              ExpansionTile(
                title: Text(
                  context.l10n.deviceToken,
                  style: context.theme.fonts.headerSmall,
                ),
                leading: Icon(
                  Icons.vpn_key_outlined,
                  color: context.theme.colors.activeButton,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.theme.colors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.theme.colors.inactiveButton,
                          width: 1,
                        ),
                      ),
                      child: SelectableText(
                        fcmToken ?? context.l10n.loading,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: fcmToken == context.l10n.notAvailable
                              ? context.theme.colors.iconRed
                              : context.theme.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(Locale currentLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.language_outlined,
              color: context.theme.colors.activeButton,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.language,
              style: context.theme.fonts.headerLarger.copyWith(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: Localization.supportedLocales.map((locale) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Text(
                      Localization.getLanguageFlag(locale.languageCode),
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Localization.getLanguageName(locale.languageCode),
                      style: context.theme.fonts.headerSmall,
                    ),
                  ],
                ),
                value: locale.languageCode,
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LocaleBloc>().add(ChangeLocaleEvent(value));
                  }
                },
                activeColor: context.theme.colors.activeButton,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.colors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    context.l10n.language,
                    style:
                        context.theme.fonts.headerLarger.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ...Localization.supportedLocales.map((locale) {
                    final isSelected =
                        state.locale.languageCode == locale.languageCode;
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.theme.colors.activeButton
                                  .withOpacity(0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          Localization.getLanguageFlag(locale.languageCode),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        Localization.getLanguageName(locale.languageCode),
                        style: context.theme.fonts.headerSmall,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: context.theme.colors.activeButton,
                            )
                          : null,
                      onTap: () {
                        context.read<LocaleBloc>().add(
                              ChangeLocaleEvent(locale.languageCode),
                            );
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
