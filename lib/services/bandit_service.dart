import 'dart:math';
import '../models/q_entry.dart';

/// Contextual Bandit：在每個 context 下直接學哪個 action 的期望獎勵最高（ε-greedy 取 argmax）
///
/// - 狀態 state = 玩家最近的出拳（上下文）→ 目前用 player_last_move
/// - 動作 action = 機器出 {剪刀, 石頭, 布}
/// - 獎勵 reward = 贏 +1、平 0、輸 -1
class JankenBandit {
  static const List<String> choices = ['剪刀', '石頭', '布'];
  static const String stateNone = '無';

  String _context = stateNone;
  final Map<String, Map<String, QEntry>> _q = {};
  static const double _epsilonInitial = 0.5;
  static const double _epsilonMin = 0.05;
  static const double _epsilonDecay = 0.995;
  final Random _rng = Random();

  int _total = 0;
  int _userWins = 0;
  int _cpuWins = 0;
  int _draws = 0;
  final Map<String, int> _whenCpuPlayedTotal = {'剪刀': 0, '石頭': 0, '布': 0};
  final Map<String, int> _whenCpuPlayedUserWins = {'剪刀': 0, '石頭': 0, '布': 0};
  final Map<String, int> _whenCpuPlayedCpuWins = {'剪刀': 0, '石頭': 0, '布': 0};
  final Map<String, int> _whenUserPrevTotal = {'剪刀': 0, '石頭': 0, '布': 0};
  final Map<String, int> _whenUserPrevUserWins = {'剪刀': 0, '石頭': 0, '布': 0};
  final Map<String, int> _whenUserPrevCpuWins = {'剪刀': 0, '石頭': 0, '布': 0};

  String? lastUserChoice;
  String? lastCpuChoice;
  String lastResult = '選一個出拳';

  int get total => _total;
  int get userWins => _userWins;
  int get cpuWins => _cpuWins;
  int get draws => _draws;
  Map<String, int> get whenCpuPlayedTotal => Map.unmodifiable(_whenCpuPlayedTotal);
  Map<String, int> get whenCpuPlayedUserWins => Map.unmodifiable(_whenCpuPlayedUserWins);
  Map<String, int> get whenCpuPlayedCpuWins => Map.unmodifiable(_whenCpuPlayedCpuWins);
  Map<String, int> get whenUserPrevTotal => Map.unmodifiable(_whenUserPrevTotal);
  Map<String, int> get whenUserPrevUserWins => Map.unmodifiable(_whenUserPrevUserWins);
  Map<String, int> get whenUserPrevCpuWins => Map.unmodifiable(_whenUserPrevCpuWins);

  QEntry _getQ(String state, String action) {
    _q[state] ??= {};
    _q[state]![action] ??= QEntry();
    return _q[state]![action]!;
  }

  double get _epsilon {
    final v = _epsilonInitial * pow(_epsilonDecay, _total).toDouble();
    return v < _epsilonMin ? _epsilonMin : v;
  }

  /// 在當前 context 下選動作：epsilon-greedy，否則 argmax_a Q(context, a)；同分隨機挑
  String selectAction() {
    if (_rng.nextDouble() < _epsilon) {
      return choices[_rng.nextInt(3)];
    }
    double bestVal = double.negativeInfinity;
    final bestActions = <String>[];
    for (final a in choices) {
      final v = _getQ(_context, a).value;
      if (v > bestVal) {
        bestVal = v;
        bestActions
          ..clear()
          ..add(a);
      } else if (v == bestVal) {
        bestActions.add(a);
      }
    }
    return bestActions[_rng.nextInt(bestActions.length)];
  }

  static int _reward(String resultText) {
    if (resultText == '你輸了') return 1;
    if (resultText == '你贏了') return -1;
    return 0;
  }

  /// 玩家出 choice；內部會更新 Q、統計、context
  void play(String userChoice) {
    final cpu = selectAction();

    String r;
    if (userChoice == cpu) {
      r = '平手';
    } else if ((userChoice == '剪刀' && cpu == '布') ||
        (userChoice == '石頭' && cpu == '剪刀') ||
        (userChoice == '布' && cpu == '石頭')) {
      r = '你贏了';
    } else {
      r = '你輸了';
    }

    final rew = _reward(r);
    final userWon = r == '你贏了';

    _total++;
    if (userWon) _userWins++;
    if (r == '你輸了') _cpuWins++;
    if (r == '平手') _draws++;

    _whenCpuPlayedTotal[cpu] = _whenCpuPlayedTotal[cpu]! + 1;
    if (userWon) _whenCpuPlayedUserWins[cpu] = _whenCpuPlayedUserWins[cpu]! + 1;
    if (r == '你輸了') _whenCpuPlayedCpuWins[cpu] = _whenCpuPlayedCpuWins[cpu]! + 1;
    if (_context != stateNone) {
      _whenUserPrevTotal[_context] = _whenUserPrevTotal[_context]! + 1;
      if (userWon) _whenUserPrevUserWins[_context] = _whenUserPrevUserWins[_context]! + 1;
      if (r == '你輸了') _whenUserPrevCpuWins[_context] = _whenUserPrevCpuWins[_context]! + 1;
    }

    final entry = _getQ(_context, cpu);
    entry.sum += rew;
    entry.count++;

    _context = userChoice;
    lastUserChoice = userChoice;
    lastCpuChoice = cpu;
    lastResult = r;
  }

  static String rateString(int wins, int total) {
    if (total == 0) return '-';
    return '${(wins / total * 100).toStringAsFixed(1)}%';
  }

  /// 勝率（不含平手）：只算 勝/(勝+負)
  static String rateStringExclDraws(int wins, int losses) {
    final total = wins + losses;
    if (total == 0) return '-';
    return '${(wins / total * 100).toStringAsFixed(1)}%';
  }
}
