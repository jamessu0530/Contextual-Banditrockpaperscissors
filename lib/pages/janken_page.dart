import 'package:flutter/material.dart';
import '../services/bandit_service.dart';
import '../widgets/janken_buttons.dart';
import '../styles/app_styles.dart';

class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  final JankenBandit _bandit = JankenBandit();

  void _play(String choice) {
    setState(() => _bandit.play(choice));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('猜拳'),
        backgroundColor: colorScheme.inversePrimary,
        foregroundColor: colorScheme.onInverseSurface,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Column(
                  children: [
                    Text('本局結果', style: AppStyles.sectionTitle(context)),
                    const SizedBox(height: AppStyles.spacingMd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LabelValue(label: '你', value: _bandit.lastUserChoice ?? '-'),
                        _LabelValue(label: '電腦', value: _bandit.lastCpuChoice ?? '-'),
                      ],
                    ),
                    const SizedBox(height: AppStyles.spacingSm),
                    Text(
                      _bandit.lastResult,
                      style: AppStyles.resultTextStyle(_bandit.lastResult, context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppStyles.spacingSm),
            Text('出拳', style: AppStyles.subsectionTitle(context)),
            const SizedBox(height: AppStyles.spacingSm),
            JankenButtons(onChoice: _play),
            const SizedBox(height: AppStyles.spacingLg),
            Text('勝率統計', style: AppStyles.sectionTitle(context)),
            const SizedBox(height: AppStyles.spacingSm),
            Card(
              child: Padding(
                padding: AppStyles.cardPaddingSmall,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('總局數：${_bandit.total}'),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(text: '你的勝率：'),
                          TextSpan(
                            text: JankenBandit.rateStringExclDraws(_bandit.userWins, _bandit.cpuWins),
                            style: TextStyle(
                              color: AppStyles.rateColor(_bandit.userWins, _bandit.cpuWins, context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '（不含平手，${_bandit.userWins} 勝 / ${_bandit.cpuWins} 負 / ${_bandit.draws} 平）',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppStyles.spacingSm),
            Text('依電腦出的手', style: AppStyles.subsectionTitle(context)),
            _StatRow('電腦出剪刀時 你的勝率', _bandit.whenCpuPlayedUserWins['剪刀']!, _bandit.whenCpuPlayedCpuWins['剪刀']!),
            _StatRow('電腦出石頭時 你的勝率', _bandit.whenCpuPlayedUserWins['石頭']!, _bandit.whenCpuPlayedCpuWins['石頭']!),
            _StatRow('電腦出布時 你的勝率', _bandit.whenCpuPlayedUserWins['布']!, _bandit.whenCpuPlayedCpuWins['布']!),
            const SizedBox(height: AppStyles.spacingSm),
            Text('依你上局出的手', style: AppStyles.subsectionTitle(context)),
            _StatRow('你上局出剪刀時 你的勝率', _bandit.whenUserPrevUserWins['剪刀']!, _bandit.whenUserPrevCpuWins['剪刀']!),
            _StatRow('你上局出石頭時 你的勝率', _bandit.whenUserPrevUserWins['石頭']!, _bandit.whenUserPrevCpuWins['石頭']!),
            _StatRow('你上局出布時 你的勝率', _bandit.whenUserPrevUserWins['布']!, _bandit.whenUserPrevCpuWins['布']!),
          ],
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppStyles.labelStyle(context)),
        const SizedBox(height: AppStyles.spacingXs),
        Text(value, style: AppStyles.labelValueStyle(context)),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.wins, this.losses);

  final String label;
  final int wins;
  final int losses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.statRowPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(
            JankenBandit.rateStringExclDraws(wins, losses),
            style: AppStyles.bodyMediumBold(context).copyWith(
              color: AppStyles.rateColor(wins, losses, context),
            ),
          ),
        ],
      ),
    );
  }
}
