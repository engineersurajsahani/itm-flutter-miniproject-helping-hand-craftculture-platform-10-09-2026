# 🏺 Helping Hand - CraftCulture Platform

> **An Empowerment Platform for Handicraft Artisans with Transparent Profit Sharing, Job Opportunities & Material Donations.**

---

## 📁 Google Drive Assets (Video Walkthrough & PDF Document)

☁️ **Google Drive Folder**: [**View Project Video & PDF Documentation on Google Drive**](https://drive.google.com/drive/folders/1KvxznmsIdZwEnrUBBAZL95M-FI4CZ3ls?usp=sharing)
> *Direct Link*: `https://drive.google.com/drive/folders/1KvxznmsIdZwEnrUBBAZL95M-FI4CZ3ls?usp=sharing`

---

## 📹 Application Video Walkthrough Demonstration

<div align="center">
  <video src="assets/demo_walkthrough.mov" width="100%" controls style="max-height: 520px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);"></video>
  <br/>
  <p><i>💡 If video playback is restricted in your browser view, <a href="https://drive.google.com/drive/folders/1KvxznmsIdZwEnrUBBAZL95M-FI4CZ3ls?usp=sharing">watch on Google Drive</a> or <a href="assets/demo_walkthrough.mov">download the video walkthrough file (assets/demo_walkthrough.mov)</a>.</i></p>
</div>

---

## 📄 Project Documentation & Academic Report

- 📖 **Official PDF Report**: [`CraftCulture_Project_Report.pdf`](CraftCulture_Project_Report.pdf) *(Includes architecture diagrams, code math logic, syllabus matrix, and oral Viva Q&A)*.
- ☁️ **Google Drive Mirror**: [**CraftCulture Drive Documentation**](https://drive.google.com/drive/folders/1KvxznmsIdZwEnrUBBAZL95M-FI4CZ3ls?usp=sharing)

### 👥 Development Team
| Sr. | Student Name | Roll Number | Primary Role / Contribution |
| :---: | :--- | :---: | :--- |
| 1 | **Om Sawant** | **045** | Lead Developer & State Architecture |
| 2 | **Prity** | **150** | UI/UX Designer & Frontend Screens |
| 3 | **Om Tripathi** | **083** | Backend & Firebase Firestore Setup |
| 4 | **Team Member 4** | **Roll No. __** | Testing, QA & Viva Documentation |

---

## ✨ Key Features & Innovation

### 1. ⚖️ Transparent 70/15/15 Profit Sharing Engine
When an item is purchased, the platform calculates Net Profit (`Price - RawMaterialCost`) and automatically splits it:
- **70% Direct Artisan Payout**: Transferred straight to the artisan's wallet.
- **15% Artisan Welfare Fund**: Dedicated to healthcare & emergency medical assistance.
- **15% Raw Material Subsidies Pool**: Provides clay, wood, yarn, and tools to underprivileged craftspeople.

### 2. 🔄 Dual-Role System (Artisan Studio vs. Buyer Marketplace)
- Instant single-tap role toggle in the top App Bar and Navigation Drawer.
- **Buyer Mode**: Catalog search, category filters (Pottery 🏺, Weaving 🧶, Woodwork 🪵, Metalcraft 🪙), impact purchase receipts, donation drives.
- **Artisan Mode**: Earning dashboard, product listing form with live profit calculation slider, job opportunities & application board.

### 3. 💼 Job Opportunities Board
- Artisans browse bulk festival orders, restoration contracts, and guild jobs.
- Single-tap modal application submission with live memory state updates.

### 4. 🎁 Money & Raw Material Donation System
- Crowd supporters donate funds or physical materials (Clay, Wood, Yarn, Looms) with real-time dynamic progress bars (`LinearProgressIndicator`).

### 5. 🎓 Built-in Viva Exam Cheat-Sheet Tab
- Integrated **Viva Guide Tab** mapping all 24 syllabus practicals directly to code concepts, logic explanations, and examiner Q&As.

---

## 🛠️ Tech Stack & System Architecture

- **Frontend**: Flutter SDK (Dart 3.x), Material Design 3, `MediaQuery` responsive grid layouts, `Hero` image transitions, custom color palette (`Terracotta` `#C85A32`, `Forest Green` `#2C5E43`, `Gold` `#D4A373`).
- **State Management**: `ChangeNotifier` and `InheritedNotifier` (`CraftStoreProvider`) for reactive UI updates.
- **Backend & Database**: Firebase Suite (`firebase_core`, `cloud_firestore` NoSQL database, `firebase_auth`, `DefaultFirebaseOptions`) with safe offline fallback handling.

---

## 📚 Syllabus Mapping Matrix (Practicals 1 – 24)

| Practical # | Topic / Concept | Code Implementation Location |
| :---: | :--- | :--- |
| **P1 - P3** | Environment Setup, `main()`, `MaterialApp`, Basic Widgets | [`lib/main.dart`](lib/main.dart) |
| **P4** | User Inputs, Forms, `GlobalKey<FormState>`, Validation | [`lib/screens/artisan/add_product_screen.dart`](lib/screens/artisan/add_product_screen.dart) |
| **P5 & P8** | Layouts (`GridView`, `Card`, `Stack`, `Expanded`, `Padding`) | [`lib/screens/buyer/product_catalog_screen.dart`](lib/screens/buyer/product_catalog_screen.dart) |
| **P6 & P9** | Custom Themes & Styling (`ThemeData`) | [`lib/theme/app_theme.dart`](lib/theme/app_theme.dart) |
| **P7** | `StatelessWidget` vs `StatefulWidget`, Lifecycle | [`lib/screens/buyer/product_detail_screen.dart`](lib/screens/buyer/product_detail_screen.dart) |
| **P10** | Navigation, `Navigator.push/pop`, `BottomNavigationBar`, `Drawer` | [`lib/screens/home_screen.dart`](lib/screens/home_screen.dart) |
| **P11** | Animations & Motion (`Hero`, `AnimatedContainer`) | [`lib/widgets/product_card.dart`](lib/widgets/product_card.dart) |
| **P12** | Interactive Controls (`ChoiceChip`, `DropdownButton`, `Radio`) | [`lib/screens/buyer/donate_screen.dart`](lib/screens/buyer/donate_screen.dart) |
| **P13** | Dialogs, Alerts & SnackBars (`AlertDialog`) | [`lib/screens/artisan/job_opportunities_screen.dart`](lib/screens/artisan/job_opportunities_screen.dart) |
| **P14** | State Management (`ChangeNotifier`, `InheritedNotifier`) | [`lib/services/craft_store_provider.dart`](lib/services/craft_store_provider.dart) |
| **P15 & P16** | Data Modeling & JSON Serialization (`fromJson`/`toJson`) | [`lib/models/product_model.dart`](lib/models/product_model.dart) |
| **P17 & P18** | Database (Cloud Firestore) & Auth (Firebase Auth) | [`lib/services/firebase_service.dart`](lib/services/firebase_service.dart) |
| **P22** | Responsive & Adaptive UI (`MediaQuery`) | [`lib/screens/buyer/product_catalog_screen.dart`](lib/screens/buyer/product_catalog_screen.dart) |

---

## ⚡ How to Run the Application

```bash
# 1. Clone the repository
git clone https://github.com/OmSawant13/itm-flutter-miniproject-helping-hand-craftculture-platform-10-09-2026.git
cd itm-flutter-miniproject-helping-hand-craftculture-platform-10-09-2026

# 2. Get Flutter dependencies
flutter pub get

# 3. Run on Chrome Web
flutter run -d chrome

# Or run on Desktop (macOS)
flutter run -d macos
```

---

## 🎓 Viva Exam Q&A Quick Reference

1. **How is state managed?** Using `ChangeNotifier` and `InheritedNotifier` (`CraftStoreScope`). Mutating state calls `notifyListeners()`, dynamically rebuilding dependent sub-trees.
2. **How does profit sharing work?** Calculates Net Profit (`Price - RawMaterialCost`), allocating 70% to direct artisan payout, 15% to welfare, and 15% to material pool.
3. **How is Firebase integrated?** `FirebaseService` initializes `DefaultFirebaseOptions.currentPlatform`, executing Cloud Firestore NoSQL operations with a fallback to local reactive storage if offline.
