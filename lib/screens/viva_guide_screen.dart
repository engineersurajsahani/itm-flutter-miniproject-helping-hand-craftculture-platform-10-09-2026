import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 1 to 24 - Comprehensive Viva Reference & Sitemap
/// LOGIC  : An interactive built-in Viva Study Sheet mapping every practical
///          in your syllabus to questions, answers, and code concepts.
/// VIVA TIP: Review this screen before your Viva exam!
/// ============================================================================

class VivaGuideScreen extends StatelessWidget {
  const VivaGuideScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _vivaTopics = const [
    {
      'title': 'Practicals 1–3: Setup, IDE & Basic Widgets',
      'concept': 'Flutter SDK architecture, Dart entry point void main(), runApp(), MaterialApp, Text, Container, Column, Row.',
      'q1': 'What is the entry point of a Flutter application?',
      'a1': 'The void main() function, which calls runApp(Widget app) to attach the root widget to the screen.',
      'q2': 'What is the difference between MaterialApp and Widget?',
      'a2': 'MaterialApp is a wrapper widget that provides Material Design routing, themes, and global navigation stack.',
    },
    {
      'title': 'Practical 4: User Inputs & Form Validation',
      'concept': 'Form, TextFormField, GlobalKey<FormState>, and validator callbacks.',
      'q1': 'How do you trigger form validation in Flutter?',
      'a1': 'By calling _formKey.currentState!.validate(), which invokes the validator callback on every child TextFormField.',
      'q2': 'What is the purpose of TextEditingController?',
      'a2': 'It manages state for a text input field, allowing code to read values, clear text, or listen for live text changes.',
    },
    {
      'title': 'Practicals 5 & 8: UI Layouts (Grid, List, Stack, Expanded)',
      'concept': 'Row, Column, GridView.builder, ListView.builder, Expanded, Flexible, Spacer, Stack, Positioned.',
      'q1': 'What is the difference between Expanded and Flexible?',
      'a1': 'Expanded forces a child widget to fill all available remaining space along the flex axis. Flexible allows a child to shrink or fit within available space without forcing expansion.',
      'q2': 'Why use GridView.builder over GridView count?',
      'a2': 'GridView.builder uses lazy loading (virtualization) so widgets are created on demand as the user scrolls, optimizing RAM.',
    },
    {
      'title': 'Practical 7: Stateful vs Stateless & Lifecycle',
      'concept': 'StatelessWidget vs StatefulWidget, initState(), setState(), dispose().',
      'q1': 'What happens when setState() is called?',
      'a1': 'It flags the StatefulWidget instance as dirty and schedules a rebuild of the element/widget subtree.',
      'q2': 'When is initState() executed?',
      'a2': 'Exactly once when the State object is first created and inserted into the element tree before build() runs.',
    },
    {
      'title': 'Practical 10: App Navigation & Routing',
      'concept': 'Navigator.push, Navigator.pop, MaterialPageRoute, BottomNavigationBar, TabBar.',
      'q1': 'How does Navigator manage routes?',
      'a1': 'Navigator uses a Stack (LIFO: Last-In, First-Out) data structure to push and pop screen routes.',
    },
    {
      'title': 'Practical 11: Animations & Motion',
      'concept': 'Hero animations, AnimatedContainer, FadeTransition.',
      'q1': 'How does Hero animation work in Flutter?',
      'a1': 'By matching two widgets across different screen routes using a shared tag string. Flutter animates size and position smoothly during navigation.',
    },
    {
      'title': 'Practical 14: State Management & Provider Pattern',
      'concept': 'ChangeNotifier, InheritedNotifier, notifyListeners().',
      'q1': 'Why use State Management instead of passing props everywhere?',
      'a1': 'Prevents prop drilling, centralizes business logic, and allows deep sub-trees to reactively rebuild without passing data down manually.',
    },
    {
      'title': 'Practical 15 & 16: Data Models & JSON Parsing',
      'concept': 'Class modeling, factory constructors (fromJson), toJson map serialization.',
      'q1': 'Why use factory constructors for JSON parsing?',
      'a1': 'A factory constructor returns an instance of a class without necessarily creating a new instance every time, perfect for mapping Map<String, dynamic> to typed Dart objects.',
    },
    {
      'title': 'Practical 22: Responsive & Adaptive UI',
      'concept': 'MediaQuery, LayoutBuilder, OrientationBuilder.',
      'q1': 'How do you check device screen size in Flutter?',
      'a1': 'Using MediaQuery.of(context).size.width and MediaQuery.of(context).size.height.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF78350F), Color(0xFFB45309)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.school, size: 40, color: Colors.amberAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Viva Exam Cheat-Sheet',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '100% syllabus mapping with potential examiner Q&A.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ..._vivaTopics.map((topic) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: const Color(0xFFFCD34D).withOpacity(0.5)),
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.menu_book, color: AppTheme.primaryCraft),
                title: Text(
                  topic['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                ),
                childrenPadding: const EdgeInsets.all(14),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡 Concept Covered', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF92400E))),
                        const SizedBox(height: 2),
                        Text(topic['concept']!, style: const TextStyle(fontSize: 12, color: Color(0xFF78350F))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _qnaBlock('Q1: ${topic['q1']}', topic['a1']!),
                  const SizedBox(height: 8),
                  if (topic.containsKey('q2')) _qnaBlock('Q2: ${topic['q2']}', topic['a2']!),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _qnaBlock(String question, String answer) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryCraft.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryCraft)),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 12, color: AppTheme.textDark, height: 1.35)),
        ],
      ),
    );
  }
}
