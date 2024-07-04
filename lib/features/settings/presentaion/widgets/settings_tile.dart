import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile(
      {super.key,
      required this.title,
      required this.icon,
      this.subtitle,
      required this.onTap});
  final String title;
  final Icon icon;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: icon,
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}
