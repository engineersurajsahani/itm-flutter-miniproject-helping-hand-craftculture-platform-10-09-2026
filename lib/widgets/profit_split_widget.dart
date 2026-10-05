import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 5, 8 & 11 - AnimatedContainer, Row, Column & Flex Layouts
/// LOGIC  : Renders an interactive bar graph showing transparent 70/15/15 profit distribution.
///          Uses AnimatedContainer to animate bar widths whenever prices change.
/// VIVA TIP: Why use AnimatedContainer over Container?
///          - AnimatedContainer automatically interpolates changes in height, width,
///            color, and curves without requiring an explicit AnimationController.
/// ============================================================================

class ProfitSplitWidget extends StatelessWidget {
  final ProfitShareBreakdown breakdown;
  final bool showHeader;

  const ProfitSplitWidget({
    Key? key,
    required this.breakdown,
    this.showHeader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalProfit = breakdown.netProfit;
    // Calculate proportions (avoid divide by zero)
    final artisanFlex = totalProfit > 0 ? (breakdown.artisanPayout / totalProfit * 100).round() : 70;
    final welfareFlex = totalProfit > 0 ? (breakdown.welfareFundPayout / totalProfit * 100).round() : 15;
    final materialFlex = totalProfit > 0 ? (breakdown.materialPoolPayout / totalProfit * 100).round() : 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          const Row(
            children: [
              Icon(Icons.pie_chart, size: 18, color: AppTheme.primaryCraft),
              SizedBox(width: 6),
              Text(
                'Transparent Profit Distribution Split',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Net Profit per sale: \$${breakdown.netProfit.toStringAsFixed(2)} (Selling \$${breakdown.totalPrice.toStringAsFixed(2)} - Raw Material \$${breakdown.rawMaterialCost.toStringAsFixed(2)})',
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 12),
        ],

        // Animated Bar Visualizer (Practical 11)
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 22,
            child: Row(
              children: [
                Expanded(
                  flex: artisanFlex > 0 ? artisanFlex : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: AppTheme.primaryCraft,
                    child: const Center(
                      child: Text(
                        '70% Artisan',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: welfareFlex > 0 ? welfareFlex : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: AppTheme.welfareFundColor,
                    child: const Center(
                      child: Text(
                        '15%',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: materialFlex > 0 ? materialFlex : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    color: AppTheme.materialPoolColor,
                    child: const Center(
                      child: Text(
                        '15%',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Detail Breakdowns List
        Row(
          children: [
            Expanded(
              child: _buildBadge(
                color: AppTheme.primaryCraft,
                title: 'Artisan Direct',
                amount: '\$${breakdown.artisanPayout.toStringAsFixed(2)}',
                subtitle: '70% Payout',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildBadge(
                color: AppTheme.welfareFundColor,
                title: 'Welfare Fund',
                amount: '\$${breakdown.welfareFundPayout.toStringAsFixed(2)}',
                subtitle: '15% Health',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildBadge(
                color: AppTheme.materialPoolColor,
                title: 'Material Pool',
                amount: '\$${breakdown.materialPoolPayout.toStringAsFixed(2)}',
                subtitle: '15% Raw',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge({
    required Color color,
    required String title,
    required String amount,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          Text(subtitle, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
