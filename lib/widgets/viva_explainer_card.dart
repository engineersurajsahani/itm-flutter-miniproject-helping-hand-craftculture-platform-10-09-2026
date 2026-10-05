import 'package:flutter/material.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 3 & 12 - Reusable Component & Expansion Tile Interactive Widget
/// LOGIC  : An interactive UI banner that displays the Flutter Syllabus Topic,
///          step-by-step logic, and potential Viva exam questions with answers.
/// VIVA TIP: Why create custom reusable widgets in Flutter?
///          - Keeps code DRY (Don't Repeat Yourself), improves maintainability,
///            and standardizes design components across screens.
/// ============================================================================

class VivaExplainerCard extends StatefulWidget {
  final String practicalTitle; // e.g., "Practical 4 - User Inputs & Validation"
  final String conceptSummary;
  final String logicExplanation;
  final String vivaTip;

  const VivaExplainerCard({
    Key? key,
    required this.practicalTitle,
    required this.conceptSummary,
    required this.logicExplanation,
    required this.vivaTip,
  }) : super(key: key);

  @override
  State<VivaExplainerCard> createState() => _VivaExplainerCardState();
}

class _VivaExplainerCardState extends State<VivaExplainerCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Soft Warm Amber
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.practicalTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF78350F),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD34D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _isExpanded ? 'Hide Viva Notes' : 'Viva Guide',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF78350F),
                            ),
                          ),
                          Icon(
                            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 16,
                            color: const Color(0xFF78350F),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded) ...[
              const Divider(height: 1, color: Color(0xFFFCD34D)),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('📖 Concept', widget.conceptSummary),
                    const SizedBox(height: 8),
                    _buildSectionHeader('⚙️ Logic & Implementation', widget.logicExplanation),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb, size: 16, color: Color(0xFFD97706)),
                              SizedBox(width: 6),
                              Text(
                                'Viva Examiner Tip',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.vivaTip,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF78350F),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF92400E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          content,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF78350F),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
