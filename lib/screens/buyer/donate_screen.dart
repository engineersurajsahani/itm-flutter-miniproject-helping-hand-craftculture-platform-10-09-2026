import 'package:flutter/material.dart';
import '../../services/craft_store_provider.dart';
import '../../models/donation_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/viva_explainer_card.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 4 & 13 - User Input Validation & Progress Indicators
/// LOGIC  : Allows supporters to donate funds or physical raw materials (Yarn, Clay, Wood).
///          Form validation verifies numeric input before updating state.
/// VIVA TIP: How does Form validation work in Flutter?
///          - Form state key (GlobalKey<FormState>) calls _formKey.currentState!.validate()
///          - Triggers validator callback in each TextFormField.
/// ============================================================================

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDonationId;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitDonation(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedDonationId != null) {
      final amount = double.parse(_amountController.text.trim());
      final store = CraftStoreScope.of(context);
      
      store.contributeDonation(_selectedDonationId!, amount);
      _amountController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Donation received! Thank you for supporting raw material pools & artisan welfare.'),
          backgroundColor: AppTheme.secondaryCraft,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final donations = store.donations;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viva Explainer Header
          const VivaExplainerCard(
            practicalTitle: 'Practical 4 & 12 - Forms, Validation & Sliders/Progress',
            conceptSummary: 'GlobalKey<FormState> validation & LinearProgressIndicator for target tracking.',
            logicExplanation: 'Validates user input with RegEx/num checks. Mutates progress ratio on contribution.',
            vivaTip: 'Why use GlobalKey<FormState>? GlobalKey uniquely identifies the Form state across widget rebuilds and provides access to validate() and save().',
          ),
          const SizedBox(height: 12),

          // Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.secondaryCraft, Color(0xFF1E4230)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.volunteer_activism, size: 42, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Artisan Support Pool',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Donate funds or raw materials (Clay, Wood, Yarn) directly to artisan clusters.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Active Donation Drives List
          const Text('Active Drives & Material Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...donations.map((item) {
            final isSelected = _selectedDonationId == item.id;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryCraft : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.type == DonationType.money
                                ? AppTheme.welfareFundColor.withOpacity(0.15)
                                : AppTheme.materialPoolColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.type == DonationType.money ? Icons.attach_money : Icons.inventory_2,
                            color: item.type == DonationType.money ? AppTheme.welfareFundColor : AppTheme.materialPoolColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(item.targetArtisanOrCluster, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: item.id,
                          groupValue: _selectedDonationId,
                          onChanged: (val) {
                            setState(() {
                              _selectedDonationId = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(item.description, style: const TextStyle(fontSize: 12, color: AppTheme.textDark)),
                    const SizedBox(height: 12),

                    // Progress Bar (Practical 12)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: item.progressPercentage,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        color: item.type == DonationType.money ? AppTheme.welfareFundColor : AppTheme.materialPoolColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Raised: ${item.raisedAmount.toStringAsFixed(0)} ${item.unit}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        Text(
                          'Goal: ${item.targetAmount.toStringAsFixed(0)} ${item.unit} (${(item.progressPercentage * 100).toStringAsFixed(0)}%)',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 16),

          // Donation Input Form (Practical 4)
          Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Make a Contribution',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryCraft),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedDonationId == null
                          ? 'Select a drive above to contribute.'
                          : 'Selected drive: ${donations.firstWhere((d) => d.id == _selectedDonationId).title}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Contribution Amount (Units / USD)',
                        hintText: 'e.g., 50',
                        prefixIcon: Icon(Icons.add_circle_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid contribution amount';
                        }
                        final parsed = double.tryParse(value);
                        if (parsed == null || parsed <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _selectedDonationId == null ? null : () => _submitDonation(context),
                        icon: const Icon(Icons.volunteer_activism),
                        label: const Text('Confirm Donation'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
