import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/craft_store_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profit_split_widget.dart';
import '../../widgets/viva_explainer_card.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 4 & 12 - Form Controls, Validation & DropdownButton/Slider
/// LOGIC  : Form for artisans to list products. Computes real-time profit split
///          breakdown as price and material cost fields are modified.
/// VIVA TIP: What is DropdownButtonFormField and Form validation?
///          - DropdownButtonFormField combines a dropdown picker with Form integration,
///            allowing validation alongside TextFormFields.
/// ============================================================================

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '50.0');
  final TextEditingController _materialCostController = TextEditingController(text: '15.0');
  final TextEditingController _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=500',
  );
  
  CraftCategory _selectedCategory = CraftCategory.pottery;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _materialCostController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  double get _currentPrice => double.tryParse(_priceController.text) ?? 50.0;
  double get _currentMaterialCost => double.tryParse(_materialCostController.text) ?? 15.0;

  void _saveProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final store = CraftStoreScope.of(context);
      final newProduct = Product(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _currentPrice,
        materialCost: _currentMaterialCost,
        category: _selectedCategory,
        artisanName: 'Ramesh Kumhar',
        artisanLocation: 'Jaipur, Rajasthan',
        imageUrl: _imageUrlController.text.trim(),
      );

      store.addProduct(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Product "${newProduct.title}" successfully listed on CraftCulture!'),
          backgroundColor: AppTheme.secondaryCraft,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBreakdown = ProfitShareBreakdown.calculate(
      price: _currentPrice,
      materialCost: _currentMaterialCost,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('List New Craft Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Viva Explainer Banner
              const VivaExplainerCard(
                practicalTitle: 'Practical 4 & 12 - Inputs, Dropdowns & Dynamic Calculations',
                conceptSummary: 'Form state validation, DropdownButtonFormField & real-time reactive preview.',
                logicExplanation: 'As price/cost fields change, setState updates currentBreakdown and re-renders ProfitSplitWidget immediately.',
                vivaTip: 'Why call setState on field changes? Re-triggers build method to recalculate live profit calculations displayed to the artisan.',
              ),
              const SizedBox(height: 12),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Product Title',
                  hintText: 'e.g. Handcarved Teak Coaster Set',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 14),

              // Category Dropdown (Practical 12)
              DropdownButtonFormField<CraftCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Craft Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: CraftCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text('${cat.iconEmoji} ${cat.displayName}'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              // Price & Raw Material Cost Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price (\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (val) => setState(() {}),
                      validator: (val) {
                        final numVal = double.tryParse(val ?? '');
                        if (numVal == null || numVal <= 0) return 'Enter valid price';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _materialCostController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Raw Material Cost (\$)',
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      onChanged: (val) => setState(() {}),
                      validator: (val) {
                        final numVal = double.tryParse(val ?? '');
                        if (numVal == null || numVal < 0) return 'Enter valid cost';
                        if (numVal >= _currentPrice) return 'Cost must be < price';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Profit Split Preview Card
              Card(
                color: AppTheme.backgroundLight,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Profit Sharing Breakdown',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                      ),
                      const SizedBox(height: 8),
                      ProfitSplitWidget(breakdown: currentBreakdown, showHeader: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Image URL & Description
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Product Image URL',
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter image URL' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Artisan Story & Craft Description',
                  hintText: 'Describe materials used, technique, and cultural heritage...',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _saveProduct(context),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Publish Product Listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
