import 'package:flutter/material.dart';
import '../services/craft_store_provider.dart';
import '../theme/app_theme.dart';
import 'buyer/product_catalog_screen.dart';
import 'buyer/donate_screen.dart';
import 'artisan/artisan_dashboard_screen.dart';
import 'artisan/add_product_screen.dart';
import 'artisan/job_opportunities_screen.dart';
import 'viva_guide_screen.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 10, 12 & 14 - BottomNavigationBar, Drawer & Role State
/// LOGIC  : Root application scaffold managing bottom navigation tab switching
///          and dual-role toggle (Buyer View vs Artisan View).
/// VIVA TIP: How does BottomNavigationBar state switching work?
///          - Managing _currentIndex in state rebuilds the IndexedStack / body widget.
/// ============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final store = CraftStoreScope.of(context);
    final isArtisan = store.currentRole == UserRole.artisan;

    // Screens per role
    final List<Widget> buyerScreens = const [
      ProductCatalogScreen(),
      DonateScreen(),
      JobOpportunitiesScreen(),
      VivaGuideScreen(),
    ];

    final List<Widget> artisanScreens = const [
      ArtisanDashboardScreen(),
      JobOpportunitiesScreen(),
      VivaGuideScreen(),
    ];

    final currentScreens = isArtisan ? artisanScreens : buyerScreens;
    if (_currentIndex >= currentScreens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.handshake, color: Colors.amberAccent),
            const SizedBox(width: 8),
            Text(isArtisan ? 'CraftCulture (Artisan Studio)' : 'Helping Hand (Artisan Marketplace)'),
          ],
        ),
        actions: [
          // Role Toggle Chip Switcher (Practical 12)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                final newRole = isArtisan ? UserRole.buyer : UserRole.artisan;
                store.toggleUserRole(newRole);
                setState(() {
                  _currentIndex = 0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Switched to ${newRole == UserRole.artisan ? "Artisan Mode" : "Buyer Mode"}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isArtisan ? Colors.amberAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isArtisan ? Icons.palette : Icons.shopping_cart,
                      size: 16,
                      color: isArtisan ? AppTheme.textDark : Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isArtisan ? 'Artisan View' : 'Buyer View',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isArtisan ? AppTheme.textDark : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Drawer Navigation (Practical 10)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.primaryCraft,
              ),
              accountName: Text(
                isArtisan ? 'Ramesh Kumhar (Master Artisan)' : 'Craft Enthusiast Donor',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                isArtisan ? 'ramesh.artisan@craftculture.org' : 'buyer.supporter@craftculture.org',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  isArtisan ? Icons.brush : Icons.favorite,
                  color: AppTheme.primaryCraft,
                  size: 30,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: AppTheme.primaryCraft),
              title: const Text('Switch Role (Artisan / Buyer)'),
              onTap: () {
                Navigator.pop(context);
                final newRole = isArtisan ? UserRole.buyer : UserRole.artisan;
                store.toggleUserRole(newRole);
                setState(() => _currentIndex = 0);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.amber),
              title: const Text('Viva Syllabus Guide & Q&A'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = currentScreens.length - 1);
              },
            ),
            if (isArtisan)
              ListTile(
                leading: const Icon(Icons.add_circle, color: AppTheme.secondaryCraft),
                title: const Text('List New Craft Product'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductScreen()),
                  );
                },
              ),
          ],
        ),
      ),

      // Body Screen
      body: currentScreens[_currentIndex],

      // Floating Action Button for Artisan (Practical 12)
      floatingActionButton: isArtisan
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Listing'),
            )
          : null,

      // Dynamic Bottom Navigation Bar (Practical 10)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryCraft,
        unselectedItemColor: AppTheme.textMuted,
        type: BottomNavigationBarType.fixed,
        items: isArtisan
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: 'Job Board',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Viva Guide',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.storefront),
                  label: 'Catalog',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.volunteer_activism),
                  label: 'Donate',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work_outline),
                  label: 'Jobs Board',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Viva Guide',
                ),
              ],
      ),
    );
  }
}
