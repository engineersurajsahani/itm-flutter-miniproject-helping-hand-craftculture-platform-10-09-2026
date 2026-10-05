import 'package:flutter/material.dart';
import '../../services/craft_store_provider.dart';
import '../../models/job_model.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/viva_explainer_card.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 5, 13 & 14 - ListView, Custom Dialogs & Multi-Role Logic
/// LOGIC  : Artisan Job Board allowing craftspeople to apply for bulk contracts
///          or post job requirements for artisan clusters.
/// VIVA TIP: How does state modification reflect across screens?
///          - Store mutates jobs list, and all listening screens receive updated applicant lists.
/// ============================================================================

class JobOpportunitiesScreen extends StatelessWidget {
  const JobOpportunitiesScreen({Key? key}) : super(key: key);

  void _showApplyDialog(BuildContext context, CraftJob job) {
    final nameController = TextEditingController(text: 'Ramesh Kumhar');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Apply for: ${job.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stipend/Budget: \$${job.stipendOrBudget.toStringAsFixed(2)} | Duration: ${job.duration}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Applicant Artisan Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final store = CraftStoreScope.of(context);
              store.applyForJob(job.id, nameController.text.trim());
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Application submitted for "${job.title}"!'),
                  backgroundColor: AppTheme.secondaryCraft,
                ),
              );
            },
            child: const Text('Submit Application'),
          ),
        ],
      ),
    );
  }

  void _showPostJobDialog(BuildContext context) {
    final titleController = TextEditingController();
    final orgController = TextEditingController();
    final budgetController = TextEditingController();
    final durationController = TextEditingController();
    final descController = TextEditingController();
    CraftCategory selectedCategory = CraftCategory.pottery;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Post Craft Opportunity'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Job Title')),
              const SizedBox(height: 8),
              TextField(controller: orgController, decoration: const InputDecoration(labelText: 'Organization / Buyer')),
              const SizedBox(height: 8),
              TextField(controller: budgetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stipend / Budget (\$)')),
              const SizedBox(height: 8),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration (e.g. 2 Weeks)')),
              const SizedBox(height: 8),
              TextField(controller: descController, maxLines: 2, decoration: const InputDecoration(labelText: 'Job Description & Craft Skills Needed')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final store = CraftStoreScope.of(context);
                final newJob = CraftJob(
                  id: 'job_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text.trim(),
                  organizationOrBuyer: orgController.text.trim().isEmpty ? 'Craft Culture Guild' : orgController.text.trim(),
                  location: 'Remote / Craft Cluster',
                  requiredCraft: selectedCategory,
                  stipendOrBudget: double.tryParse(budgetController.text) ?? 500.0,
                  duration: durationController.text.trim().isEmpty ? '1 Month' : durationController.text.trim(),
                  description: descController.text.trim().isEmpty ? 'Craft artisan needed.' : descController.text.trim(),
                );
                store.addJob(newJob);
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Publish Job'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final jobs = store.jobs;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viva Explainer Banner
          const VivaExplainerCard(
            practicalTitle: 'Practical 5 & 13 - ListView, Alerts & Job Management',
            conceptSummary: 'Dynamic list rendering with custom modal alert dialogs for applications.',
            logicExplanation: 'Artisans review required craft skills, stipend, and submit applications stored in memory state.',
            vivaTip: 'What is showDialog? Displays a popup overlay on top of the widget tree with barrierDismissible background.',
          ),
          const SizedBox(height: 10),

          // Header Banner & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Artisan Job Opportunity Board', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Bulk orders, restoration contracts & guild jobs', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showPostJobDialog(context),
                icon: const Icon(Icons.work_outline, size: 16),
                label: const Text('Post Job'),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...jobs.map((job) {
            final hasApplied = job.applicantNames.contains('Ramesh Kumhar');
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
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
                            color: AppTheme.primaryCraft.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(job.requiredCraft.iconEmoji, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${job.organizationOrBuyer} • ${job.location}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(job.description, style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.3)),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryCraft.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Budget: \$${job.stipendOrBudget.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryCraft),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Duration: ${job.duration}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: hasApplied ? null : () => _showApplyDialog(context, job),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasApplied ? Colors.grey : AppTheme.primaryCraft,
                          ),
                          child: Text(hasApplied ? 'Applied ✓' : 'Apply Now'),
                        ),
                      ],
                    ),
                    if (job.applicantNames.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Applicants (${job.applicantNames.length}): ${job.applicantNames.join(", ")}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
