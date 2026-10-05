import 'package:flutter/material.dart';
import 'services/craft_store_provider.dart';
import 'services/firebase_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 1, 2, 3, 17 & 18 - Entry Point, MaterialApp & Firebase Initialization
/// LOGIC  : main() initializes the app root widget hierarchy & FirebaseService.
///          CraftStoreScope provides global state access to all child screens.
/// VIVA TIP: What happens inside main()?
///          - main() is the C-style entry point called by the Dart VM.
///          - runApp() inflates the widget tree and attaches it to the screen viewport.
/// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HelpingHandCraftCultureApp());
}

class HelpingHandCraftCultureApp extends StatefulWidget {
  const HelpingHandCraftCultureApp({Key? key}) : super(key: key);

  @override
  State<HelpingHandCraftCultureApp> createState() => _HelpingHandCraftCultureAppState();
}

class _HelpingHandCraftCultureAppState extends State<HelpingHandCraftCultureApp> {
  late final CraftStoreProvider _storeProvider;

  @override
  void initState() {
    super.initState();
    _storeProvider = CraftStoreProvider();
    FirebaseService().initializeFirebase();
  }

  @override
  void dispose() {
    _storeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CraftStoreScope(
      notifier: _storeProvider,
      child: MaterialApp(
        title: 'Helping Hand - CraftCulture Platform',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
