import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/craft_store_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profit_split_widget.dart';
import '../../widgets/viva_explainer_card.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 7, 10 & 13 - Navigation, Dialogs, & Stateful Lifecycle
/// LOGIC  : Detailed view for an artisan item with Hero transition.
///          Invokes purchaseProduct on store and triggers AlertDialog receipt.
/// VIVA TIP: What is Navigator.pop and showDialog?
///          - showDialog displays a modal dialog above the current screen content.
///          - Navigator.pop removes the topmost route/dialog from the stack.
/// ============================================================================

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final String heroTag;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.heroTag,
  }) : super(key: key);

  void _handleBuyAction(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final breakdown = product.profitBreakdown;

    // Process Purchase State Update
    store.purchaseProduct(product);

    // Show Digital Purchase Receipt Dialog (Practical 13)
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.verified, color: AppTheme.secondaryCraft, size: 28),
            SizedBox(width: 8),
            Text('Impact Purchase Receipt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thank you for empowering ${product.artisanName}!',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    _receiptRow('Item', product.title),
                    _receiptRow('Price Paid', '\$${product.price.toStringAsFixed(2)}'),
                    const Divider(),
                    _receiptRow('Direct to Artisan (70%)', '\$${breakdown.artisanPayout.toStringAsFixed(2)}', isBold: true, color: AppTheme.primaryCraft),
                    _receiptRow('Artisan Welfare (15%)', '\$${breakdown.welfareFundPayout.toStringAsFixed(2)}', color: AppTheme.welfareFundColor),
                    _receiptRow('Raw Material Pool (15%)', '\$${breakdown.materialPoolPayout.toStringAsFixed(2)}', color: AppTheme.materialPoolColor),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '✨ Your funds have been instantly split and credited to the artisan\'s digital account.',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order placed for ${product.title}! Earnings credited.'),
                  backgroundColor: AppTheme.secondaryCraft,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Awesome! Done'),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String title, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: color ?? AppTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakdown = product.profitBreakdown;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product link copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Hero Image (Practical 11)
            Hero(
              tag: heroTag,
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.accentGold.withOpacity(0.3),
                    child: Center(
                      child: Text(product.category.iconEmoji, style: const TextStyle(fontSize: 72)),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Viva Explainer for Dialogs & Navigation
                  const VivaExplainerCard(
                    practicalTitle: 'Practical 10 & 13 - Navigation & Alert Dialogs',
                    conceptSummary: 'Navigator route stack push/pop & modal AlertDialog receipt generation.',
                    logicExplanation: 'When "Buy Now" is tapped, state is mutated in CraftStoreProvider and a custom modal AlertDialog presents the 70/15/15 profit breakdown.',
                    vivaTip: 'What is ScaffoldMessenger? Used to display lightweight floating notification bars (SnackBars) to inform users of async operations.',
                  ),
                  const SizedBox(height: 12),

                  // Title & Price Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryCraft),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Artisan Profile Info Tag
                  Card(
                    elevation: 0,
                    color: AppTheme.primaryCraft.withOpacity(0.06),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.primaryCraft,
                            child: Text(
                              product.artisanName[0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crafted by ${product.artisanName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 12, color: AppTheme.textMuted),
                                  const SizedBox(width: 2),
                                  Text(
                                    product.artisanLocation,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryCraft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Verified Artisan',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Artisan Heritage Story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Profit Distribution Interactive Component
                  ProfitSplitWidget(breakdown: breakdown),
                  const SizedBox(height: 28),

                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleBuyAction(context),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text('Buy Product & Direct Payout (\$${breakdown.artisanPayout.toStringAsFixed(2)} to Artisan)'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
