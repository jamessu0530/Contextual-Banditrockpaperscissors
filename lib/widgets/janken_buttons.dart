import 'package:flutter/material.dart';

/// 剪刀 / 石頭 / 布 三個出拳按鈕
class JankenButtons extends StatelessWidget {
  const JankenButtons({super.key, required this.onChoice});

  final void Function(String choice) onChoice;

  static const List<String> choices = ['剪刀', '石頭', '布'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styles = [
      ElevatedButton.styleFrom(backgroundColor: scheme.primaryContainer),
      ElevatedButton.styleFrom(backgroundColor: scheme.secondaryContainer),
      ElevatedButton.styleFrom(backgroundColor: scheme.tertiaryContainer),
    ];
    return Row(
      children: [
        for (var i = 0; i < choices.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => onChoice(choices[i]),
              style: styles[i],
              child: Text(choices[i]),
            ),
          ),
        ],
      ],
    );
  }
}
