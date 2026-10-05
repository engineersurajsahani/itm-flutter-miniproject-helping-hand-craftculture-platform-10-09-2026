import 'package:flutter/material.dart';
import '../../services/craft_store_provider.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/viva_explainer_card.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 5, 12 & 22 - GridView, Search Inputs, & Responsive Layout
/// LOGIC  : Displays the artisan product catalog. Reactively updates grid items
///          when search queries or category filters are selected via CraftStoreProvider.
/// VIVA TIP: How to handle responsive layouts in Flutter?
///          - MediaQuery.of(context).size allows dynamic column count calculation
///          - GridView.builder lazily builds visible items to optimize memory.
/// ============================================================================

class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final products = store.products;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viva Explanation Banner for Syllabus Practical 5 & 22
          const VivaExplainerCard(
            practicalTitle: 'Practical 5 & 22 - GridView & Adaptive Responsive UI',
            conceptSummary: 'GridView.builder with SliverGridDelegate & MediaQuery responsive width detection.',
            logicExplanation: 'Reads screen width dynamically; chooses 2 columns for mobile and 3 columns for tablet. Filters list reactively.',
            vivaTip: 'Why use GridView.builder instead of GridView count? GridView.builder is lazily loaded (allocates memory only for items currently visible on screen).',
          ),
          const SizedBox(height: 8),

          // Search Input Bar (Practical 4 & 12)
          TextField(
            onChanged: (value) => store.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Search terracotta, handloom, woodwork...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.primaryCraft),
              suffixIcon: store.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => store.setSearchQuery(''),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),

          // Category Choice Chips (Practical 12 - ChoiceChip)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: const Text('All Crafts ✨'),
                    selected: store.selectedCategory == null,
                    onSelected: (selected) {
                      if (selected) store.setCategoryFilter(null);
                    },
                    selectedColor: AppTheme.primaryCraft,
                    labelStyle: TextStyle(
                      color: store.selectedCategory == null ? Colors.white : AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...CraftCategory.values.map((cat) {
                  final isSelected = store.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text('${cat.iconEmoji} ${cat.displayName}'),
                      selected: isSelected,
                      onSelected: (selected) {
                        store.setCategoryFilter(selected ? cat : null);
                      },
                      selectedColor: AppTheme.primaryCraft,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Catalog Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Handcrafted Items (${products.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const Text(
                '100% Verified Artisans',
                style: TextStyle(fontSize: 12, color: AppTheme.secondaryCraft, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Product Grid (Practical 5 & 8)
          products.isEmpty
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
                      SizedBox(height: 8),
                      Text('No artisan products match your filter.', style: TextStyle(color: AppTheme.textMuted)),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
        ],
      ),
    );
  }
}
