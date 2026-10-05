import 'package:flutter/material.dart';
import '../../services/craft_store_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profit_split_widget.dart';
import '../../widgets/viva_explainer_card.dart';
import 'add_product_screen.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 5, 8 & 14 - Layout Cards & Reactive State Dashboard
/// LOGIC  : Displays artisan metrics (total revenue, direct payout, welfare funds).
///          Reads real-time state from CraftStoreProvider.
/// VIVA TIP: Why use Column/Row flex layout inside Cards?
///          - Offers responsive metric counters and stats cards that scale across screen sizes.
/// ============================================================================

class ArtisanDashboardScreen extends StatelessWidget {
  const ArtisanDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final products = store.products;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viva Explainer Header
          const VivaExplainerCard(
            practicalTitle: 'Practical 8 & 14 - Cards, Layouts & State Observer',
            conceptSummary: 'Dashboard state management with metric counters & Card widgets.',
            logicExplanation: 'Calculates overall artisan earnings, 70% direct payouts, and 15% community pool contributions.',
            vivaTip: 'How to update state when a product is added or purchased? Calling notifyListeners() triggers dependent widgets to rebuild with updated figures.',
          ),
          const SizedBox(height: 10),

          // Earning Overview Banner
          Card(
            color: AppTheme.primaryCraft,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Artisan Financial Dashboard', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('Ramesh Kumhar', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.stars, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text('Master Craftsperson', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _metricStat(
                          label: 'Total Sales',
                          value: '\$${store.totalSalesRevenue.toStringAsFixed(2)}',
                          sub: '${store.completedOrdersCount} Orders',
                        ),
                      ),
                      Expanded(
                        child: _metricStat(
                          label: 'Your Payout (70%)',
                          value: '\$${store.totalArtisanEarnings.toStringAsFixed(2)}',
                          sub: 'Direct Bank Credit',
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _metricStat(
                          label: 'Welfare (15%)',
                          value: '\$${store.totalWelfareFundContributed.toStringAsFixed(2)}',
                          sub: 'Health Pool',
                        ),
                      ),
                      Expanded(
                        child: _metricStat(
                          label: 'Material Pool (15%)',
                          value: '\$${store.totalMaterialPoolContributed.toStringAsFixed(2)}',
                          sub: 'Raw Subsidies',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Action Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Product Listings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Product'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Artisan Products List
          ...products.map((product) {
            final breakdown = product.profitBreakdown;
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Container(
                                color: AppTheme.accentGold.withOpacity(0.3),
                                child: Center(child: Text(product.category.iconEmoji)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('Selling Price: \$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.primaryCraft, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ProfitSplitWidget(breakdown: breakdown, showHeader: false),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _metricStat({required String label, required String value, required String sub, Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: color ?? Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}
