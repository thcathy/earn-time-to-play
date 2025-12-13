import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/time_bank_provider.dart';
import '../../utils/time_utils.dart';
import '../../widgets/app_card.dart';
import '../../widgets/theme_toggle.dart';

/// Analytics dashboard with charts and statistics
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timeBankProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              title: Text(l10n?.analytics ?? 'Analytics'),
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),

            if (state.entries.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.barChart3,
                        size: 64,
                        color: theme.colorScheme.outline.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.noEntriesYet ?? 'No data yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n?.startTrackingMessage ?? 'Start tracking your time to see analytics',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats cards
                    _StatsGrid(state: state),
                    const SizedBox(height: 24),

                    // Weekly bar chart
                    _ChartCard(
                      title: l10n?.weeklyOverview ?? 'This Week',
                      subtitle: '${l10n?.focus ?? "Focus"} vs ${l10n?.play ?? "Play"}',
                      child: _WeeklyBarChart(state: state),
                    ),
                    const SizedBox(height: 16),

                    // Balance trend
                    _ChartCard(
                      title: l10n?.balanceTrend ?? 'Balance Trend',
                      subtitle: '14 ${l10n?.days ?? "days"}',
                      child: _BalanceTrendChart(state: state),
                    ),
                    const SizedBox(height: 16),

                    // Time distribution pie chart
                    _ChartCard(
                      title: l10n?.timeDistribution ?? 'Time Distribution',
                      subtitle: l10n?.allTime ?? 'All time',
                      child: _TimeDistributionChart(state: state),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final TimeBankState state;

  const _StatsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: l10n?.totalFocus ?? 'Total Focus',
          value: TimeUtils.formatMinutesAsHours(state.totalFocusMinutes),
          icon: LucideIcons.bookOpen,
          color: isDark ? AppColors.focusDark : AppColors.focusLight,
        ),
        _StatCard(
          title: l10n?.totalPlay ?? 'Total Play',
          value: TimeUtils.formatMinutesAsHours(state.totalPlayMinutes),
          icon: LucideIcons.gamepad2,
          color: isDark ? AppColors.playDark : AppColors.playLight,
        ),
        _StatCard(
          title: l10n?.avgDailyDelta ?? 'Avg Daily Delta',
          value: TimeUtils.formatMinutesWithSign(state.averageDailyDelta.round()),
          icon: LucideIcons.trendingUp,
          color: state.averageDailyDelta >= 0
              ? (isDark ? AppColors.focusDark : AppColors.focusLight)
              : AppColors.error,
        ),
        _StatCard(
          title: l10n?.positiveStreak ?? 'Positive Streak',
          value: '${state.positiveBalanceStreak} ${l10n?.days ?? "days"}',
          icon: LucideIcons.flame,
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const Spacer(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final TimeBankState state;

  const _WeeklyBarChart({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final focusColor = isDark ? AppColors.focusDark : AppColors.focusLight;
    final playColor = isDark ? AppColors.playDark : AppColors.playLight;

    // Get last 7 days of data
    final last7Days = TimeUtils.getLastNDays(7).reversed.toList();
    final entriesMap = {for (var e in state.entries) e.date: e};

    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < last7Days.length; i++) {
      final date = last7Days[i];
      final entry = entriesMap[date];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (entry?.learningMinutes ?? 0).toDouble(),
              color: focusColor,
              width: 12,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: (entry?.gamingMinutes ?? 0).toDouble(),
              color: playColor,
              width: 12,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= last7Days.length) {
                    return const SizedBox.shrink();
                  }
                  final date = TimeUtils.parseDate(last7Days[index]);
                  final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      dayNames[date.weekday - 1],
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceTrendChart extends StatelessWidget {
  final TimeBankState state;

  const _BalanceTrendChart({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lineColor = isDark ? AppColors.focusDark : AppColors.focusLight;

    // Calculate balance trend for last 14 days
    final last14Days = TimeUtils.getLastNDays(14).reversed.toList();
    final entriesMap = {for (var e in state.entries) e.date: e};

    int balance = state.settings.startingBalance;
    final spots = <FlSpot>[];

    // Sort all entries by date
    final allDates = state.entries.map((e) => e.date).toList()..sort();

    // Calculate balance up to the start of our 14-day window
    for (final date in allDates) {
      if (date.compareTo(last14Days.first) < 0) {
        final entry = entriesMap[date];
        if (entry != null) {
          balance += entry.delta;
        }
      }
    }

    // Now track balance for the 14-day window
    for (var i = 0; i < last14Days.length; i++) {
      final date = last14Days[i];
      final entry = entriesMap[date];
      if (entry != null) {
        balance += entry.delta;
      }
      spots.add(FlSpot(i.toDouble(), balance.toDouble()));
    }

    final minY = spots.isEmpty ? 0.0 : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.isEmpty ? 100.0 : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY - minY) / 4).clamp(1, double.infinity),
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outline.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: minY - padding,
          maxY: maxY + padding,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 3,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= last14Days.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      TimeUtils.formatDateShort(last14Days[index]),
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    TimeUtils.formatMinutesWithSign(spot.y.toInt()),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeDistributionChart extends StatelessWidget {
  final TimeBankState state;

  const _TimeDistributionChart({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final focusColor = isDark ? AppColors.focusDark : AppColors.focusLight;
    final playColor = isDark ? AppColors.playDark : AppColors.playLight;
    final l10n = AppLocalizations.of(context);

    final totalFocus = state.totalFocusMinutes;
    final totalPlay = state.totalPlayMinutes;
    final total = totalFocus + totalPlay;

    if (total == 0) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(l10n?.noEntriesYet ?? 'No data'),
        ),
      );
    }

    final focusPercent = (totalFocus / total * 100).round();
    final playPercent = (totalPlay / total * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: totalFocus.toDouble(),
                  color: focusColor,
                  title: '',
                  radius: 30,
                ),
                PieChartSectionData(
                  value: totalPlay.toDouble(),
                  color: playColor,
                  title: '',
                  radius: 30,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem(
                color: focusColor,
                label: l10n?.focus ?? 'Focus',
                value: '$focusPercent%',
                subtitle: TimeUtils.formatMinutesAsHours(totalFocus),
              ),
              const SizedBox(height: 16),
              _LegendItem(
                color: playColor,
                label: l10n?.play ?? 'Play',
                value: '$playPercent%',
                subtitle: TimeUtils.formatMinutesAsHours(totalPlay),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String subtitle;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(label, style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
