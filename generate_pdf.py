import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, HRFlowable, KeepTogether
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        if self._pageNumber == 1:
            return  # Suppress headers/footers on cover page

        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#756A63"))

        # Header line & text
        self.setLineWidth(0.5)
        self.setStrokeColor(colors.HexColor("#C85A32"))
        self.line(54, 11 * inch - 36, 8.5 * inch - 54, 11 * inch - 36)
        
        self.drawString(54, 11 * inch - 30, "HELPING HAND - CRAFTCULTURE PLATFORM | PROJECT REPORT")
        self.drawRightString(8.5 * inch - 54, 11 * inch - 30, "FLUTTER & FIREBASE DEVELOPMENT")

        # Footer line & text
        self.line(54, 45, 8.5 * inch - 54, 45)
        self.setFont("Helvetica", 9)
        self.drawString(54, 30, "Confidential Academic Project Documentation")
        self.drawRightString(8.5 * inch - 54, 30, f"Page {self._pageNumber} of {page_count}")
        self.restoreState()

def create_project_report_pdf(filename):
    doc = SimpleDocTemplate(
        filename,
        pagesize=letter,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54,
    )

    styles = getSampleStyleSheet()

    # Custom Palette
    c_primary = colors.HexColor("#C85A32")    # Terracotta
    c_secondary = colors.HexColor("#2C5E43")  # Forest Green
    c_dark = colors.HexColor("#2D2321")       # Charcoal
    c_accent = colors.HexColor("#D4A373")     # Gold
    c_bg_light = colors.HexColor("#FAF7F2")   # Warm White
    c_muted = colors.HexColor("#756A63")

    # Custom Typography Styles
    title_style = ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=28,
        leading=34,
        textColor=c_primary,
        alignment=1, # Center
        spaceAfter=10
    )

    subtitle_style = ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=13,
        leading=18,
        textColor=c_dark,
        alignment=1,
        spaceAfter=30
    )

    h1_style = ParagraphStyle(
        'SectionH1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=18,
        leading=22,
        textColor=c_primary,
        spaceBefore=14,
        spaceAfter=8,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'SectionH2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=16,
        textColor=c_secondary,
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyDark',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14,
        textColor=c_dark,
        spaceAfter=8
    )

    bullet_style = ParagraphStyle(
        'BulletDark',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14,
        textColor=c_dark,
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )

    code_style = ParagraphStyle(
        'CodeSnippet',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=9,
        leading=12,
        textColor=colors.HexColor("#1F2937"),
        backColor=colors.HexColor("#F3F4F6"),
        borderColor=colors.HexColor("#E5E7EB"),
        borderWidth=1,
        borderPadding=6,
        spaceAfter=8
    )

    story = []

    # =========================================================================
    # COVER PAGE
    # =========================================================================
    story.append(Spacer(1, 40))
    story.append(Paragraph("HELPING HAND - CRAFTCULTURE PLATFORM", title_style))
    story.append(HRFlowable(width="60%", thickness=3, color=c_accent, spaceBefore=5, spaceAfter=15))
    story.append(Paragraph("An Empowerment Platform for Handicraft Artisans with Profit Sharing, Job Opportunities & Material Donations", subtitle_style))
    story.append(Spacer(1, 30))

    # Decorative Box for Project Details
    proj_info_data = [
        [Paragraph("<b>Course / Subject:</b>", body_style), Paragraph("Flutter Application & Firebase Development", body_style)],
        [Paragraph("<b>Project Category:</b>", body_style), Paragraph("Full-Stack Mobile & Web Application", body_style)],
        [Paragraph("<b>Database Backend:</b>", body_style), Paragraph("Firebase Cloud Firestore & Local Reactive State", body_style)],
        [Paragraph("<b>Frontend Framework:</b>", body_style), Paragraph("Flutter SDK (Dart 3.x), Material Design 3", body_style)],
        [Paragraph("<b>Academic Scope:</b>", body_style), Paragraph("Complete Practical Syllabus Alignment (Practicals 1 - 24)", body_style)],
        [Paragraph("<b>Google Drive Assets:</b>", body_style), Paragraph("<font color='#C85A32'><u>https://drive.google.com/drive/folders/1KvxznmsIdZwEnrUBBAZL95M-FI4CZ3ls?usp=sharing</u></font>", body_style)],
    ]
    t_proj_info = Table(proj_info_data, colWidths=[1.8 * inch, 4.5 * inch])
    t_proj_info.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), c_bg_light),
        ('BOX', (0, 0), (-1, -1), 1.5, c_primary),
        ('PADDING', (0, 0), (-1, -1), 10),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
    ]))
    story.append(t_proj_info)
    story.append(Spacer(1, 40))

    # Team Members Table
    story.append(Paragraph("<b>PROJECT DEVELOPMENT TEAM</b>", ParagraphStyle('TeamHeader', fontName='Helvetica-Bold', fontSize=12, alignment=1, textColor=c_secondary)))
    story.append(Spacer(1, 10))

    team_data = [
        [Paragraph("<b>Sr.</b>", body_style), Paragraph("<b>Student Name</b>", body_style), Paragraph("<b>Roll Number</b>", body_style), Paragraph("<b>Role / Contribution</b>", body_style)],
        [Paragraph("1", body_style), Paragraph("<b>Om Sawant</b>", body_style), Paragraph("<b>045</b>", body_style), Paragraph("Lead Developer & State Architecture", body_style)],
        [Paragraph("2", body_style), Paragraph("<b>Prity</b>", body_style), Paragraph("<b>150</b>", body_style), Paragraph("UI/UX Designer & Frontend Screens", body_style)],
        [Paragraph("3", body_style), Paragraph("<b>Om Tripathi</b>", body_style), Paragraph("<b>083</b>", body_style), Paragraph("Backend & Firebase Firestore Setup", body_style)],
        [Paragraph("4", body_style), Paragraph("<b>Team Member 4</b>", body_style), Paragraph("<b>Roll No. __</b>", body_style), Paragraph("Testing, QA & Viva Documentation", body_style)],
    ]
    t_team = Table(team_data, colWidths=[0.5 * inch, 2.2 * inch, 1.3 * inch, 2.3 * inch])
    t_team.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), c_primary),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0, 0), (-1, -1), 8),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
    ]))
    story.append(t_team)

    story.append(PageBreak())

    # =========================================================================
    # 1. EXECUTIVE SUMMARY & OBJECTIVES
    # =========================================================================
    story.append(Paragraph("1. Executive Summary & Objectives", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_primary, spaceBefore=2, spaceAfter=10))

    story.append(Paragraph(
        "Handicraft artisans represent the rich cultural heritage of rural communities. However, traditional craftspeople face severe challenges such as exploitation by middlemen, lack of price transparency, insufficient raw material capital, and limited direct access to buyers. "
        "<b>Helping Hand - CraftCulture Platform</b> addresses these core issues through an integrated digital solution built with <b>Flutter</b> and <b>Firebase</b>.",
        body_style
    ))

    story.append(Paragraph("Key Objectives of the Platform:", h2_style))
    story.append(Paragraph("• <b>Artisan Empowerment:</b> Direct marketplace listing eliminating intermediary exploitation.", bullet_style))
    story.append(Paragraph("• <b>Transparent Profit Sharing:</b> Automated 70/15/15 profit distribution algorithm for direct artisan payouts, welfare funds, and raw material pools.", bullet_style))
    story.append(Paragraph("• <b>Job Opportunities Management:</b> Dedicated job board connecting craftspeople with bulk festival orders and restoration contracts.", bullet_style))
    story.append(Paragraph("• <b>Material & Financial Donations:</b> Crowd-supported raw material pool (clay, wood, yarn, tools) with live target progress tracking.", bullet_style))
    story.append(Paragraph("• <b>Dual-Role Navigation:</b> Instant role switching between Artisan Studio and Buyer Marketplace views.", bullet_style))

    story.append(Spacer(1, 14))

    # =========================================================================
    # 2. SYSTEM ARCHITECTURE (FRONTEND & BACKEND)
    # =========================================================================
    story.append(Paragraph("2. System Architecture & Tech Stack", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_primary, spaceBefore=2, spaceAfter=10))

    story.append(Paragraph("Frontend Architecture (Flutter SDK)", h2_style))
    story.append(Paragraph(
        "The frontend is developed using <b>Flutter 3.x</b> and <b>Dart</b>, providing a native cross-platform experience across Web, Android, iOS, and macOS. "
        "The user interface follows <b>Material Design 3</b> principles, incorporating custom typography, curated terracotta/gold themes, and micro-animations.",
        body_style
    ))

    story.append(Paragraph("Key Frontend Patterns:", body_style))
    story.append(Paragraph("• <b>State Management:</b> Uses <code>ChangeNotifier</code> and <code>InheritedNotifier</code> (<code>CraftStoreProvider</code>) for reactive UI updates without third-party boilerplate.", bullet_style))
    story.append(Paragraph("• <b>Responsive Layouts:</b> Utilizes <code>MediaQuery</code> and <code>GridView.builder</code> to dynamically adjust grid columns across screen viewports.", bullet_style))
    story.append(Paragraph("• <b>Motion & Transitions:</b> Implements <code>Hero</code> image tags and <code>AnimatedContainer</code> for smooth visual feedback during route navigation.", bullet_style))
    story.append(Paragraph("• <b>Form Controls & Validation:</b> Employs <code>GlobalKey&lt;FormState&gt;</code> and custom validators for numeric input verification.", bullet_style))

    story.append(Spacer(1, 8))
    story.append(Paragraph("Backend Architecture (Firebase Suite)", h2_style))
    story.append(Paragraph(
        "The backend layer leverages <b>Firebase</b> services to provide scalable cloud data management and secure user authentication.",
        body_style
    ))

    backend_data = [
        [Paragraph("<b>Firebase Service</b>", body_style), Paragraph("<b>Implementation & Usage in Project</b>", body_style)],
        [Paragraph("<b>Firebase Core</b>", body_style), Paragraph("Initializes cross-platform configurations via <code>DefaultFirebaseOptions</code>.", body_style)],
        [Paragraph("<b>Cloud Firestore</b>", body_style), Paragraph("NoSQL Document Database managing <code>products</code>, <code>jobs</code>, and <code>donations</code> collections with real-time <code>snapshots()</code>.", body_style)],
        [Paragraph("<b>Firebase Auth</b>", body_style), Paragraph("User registration and login using <code>createUserWithEmailAndPassword()</code> and <code>signInWithEmailAndPassword()</code>.", body_style)],
        [Paragraph("<b>Offline Fallback</b>", body_style), Paragraph("Robust <code>try-catch</code> wrapper in <code>FirebaseService</code> enabling seamless local mock mode execution if offline.", body_style)],
    ]
    t_backend = Table(backend_data, colWidths=[2.0 * inch, 4.3 * inch])
    t_backend.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), c_secondary),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0, 0), (-1, -1), 6),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
    ]))
    story.append(t_backend)

    story.append(PageBreak())

    # =========================================================================
    # 3. KEY FUNCTIONAL MODULES
    # =========================================================================
    story.append(Paragraph("3. Core Functional Modules", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_primary, spaceBefore=2, spaceAfter=10))

    story.append(Paragraph("Module 1: 70/15/15 Profit Sharing Algorithm", h2_style))
    story.append(Paragraph(
        "When an item is purchased, the platform automatically calculates the Net Profit (Selling Price minus Raw Material Cost) and splits it into three transparent streams:",
        body_style
    ))
    story.append(Paragraph("1. <b>70% Direct Artisan Payout:</b> Transferred directly to the artisan's account.", bullet_style))
    story.append(Paragraph("2. <b>15% Welfare Fund:</b> Allocated to community healthcare and emergency support.", bullet_style))
    story.append(Paragraph("3. <b>15% Raw Material Pool:</b> Subsidizes raw materials (clay, wood, yarn) for underprivileged craftspeople.", bullet_style))

    story.append(Spacer(1, 6))
    story.append(Paragraph("Formula Implementation Code Snippet:", body_style))
    story.append(Paragraph(
"""final netProfit = (price - materialCost).clamp(0.0, double.infinity);
final artisanCut = netProfit * 0.70;
final welfareCut = netProfit * 0.15;
final materialCut = netProfit * 0.15;""", code_style
    ))

    story.append(Spacer(1, 8))
    story.append(Paragraph("Module 2: Artisan & Buyer Dashboards", h2_style))
    story.append(Paragraph(
        "• <b>Artisan Dashboard:</b> Displays cumulative sales revenue, direct 70% earnings, welfare pool contributions, and active listings management.<br/>"
        "• <b>Buyer Dashboard:</b> Features product catalog search, category filtering, digital impact purchase receipt dialogs, and contribution history.",
        body_style
    ))

    story.append(Spacer(1, 8))
    story.append(Paragraph("Module 3: Job Opportunity Board & Donations", h2_style))
    story.append(Paragraph(
        "• <b>Job Board:</b> Artisans view required craft skills, duration, and stipend budgets for bulk orders, submitting single-tap applications.<br/>"
        "• <b>Donation System:</b> Enables crowd contributions of money or raw materials (clay, wood, yarn, machinery) with progress tracking.",
        body_style
    ))

    story.append(Spacer(1, 14))

    # =========================================================================
    # 4. SYLLABUS MAPPING MATRIX (PRACTICALS 1 - 24)
    # =========================================================================
    story.append(Paragraph("4. Syllabus Mapping Matrix (Practicals 1 - 24)", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_primary, spaceBefore=2, spaceAfter=10))

    syllabus_data = [
        [Paragraph("<b>Practical Topic</b>", body_style), Paragraph("<b>Description & Concept Covered</b>", body_style), Paragraph("<b>Implementation Location</b>", body_style)],
        [Paragraph("<b>P1 - P3</b>", body_style), Paragraph("Setup, IDE Tools, main(), MaterialApp, Basic Widgets", body_style), Paragraph("<code>main.dart</code>", body_style)],
        [Paragraph("<b>P4</b>", body_style), Paragraph("User Inputs, Forms, GlobalKey Validation", body_style), Paragraph("<code>add_product_screen.dart</code>", body_style)],
        [Paragraph("<b>P5 & P8</b>", body_style), Paragraph("UI Layouts (GridView, Card, Stack, Expanded)", body_style), Paragraph("<code>product_catalog_screen.dart</code>", body_style)],
        [Paragraph("<b>P6 & P9</b>", body_style), Paragraph("Custom Themes, Palette & Fonts (ThemeData)", body_style), Paragraph("<code>theme/app_theme.dart</code>", body_style)],
        [Paragraph("<b>P7</b>", body_style), Paragraph("Stateful vs Stateless Widget Lifecycle", body_style), Paragraph("<code>product_detail_screen.dart</code>", body_style)],
        [Paragraph("<b>P10</b>", body_style), Paragraph("App Navigation, Navigator, BottomNavBar, Drawer", body_style), Paragraph("<code>screens/home_screen.dart</code>", body_style)],
        [Paragraph("<b>P11</b>", body_style), Paragraph("Animations & Motion (Hero, AnimatedContainer)", body_style), Paragraph("<code>widgets/product_card.dart</code>", body_style)],
        [Paragraph("<b>P12</b>", body_style), Paragraph("Interactive Widgets (ChoiceChip, Dropdown, Radio)", body_style), Paragraph("<code>donate_screen.dart</code>", body_style)],
        [Paragraph("<b>P13</b>", body_style), Paragraph("Dialogs, Alerts & SnackBars (AlertDialog)", body_style), Paragraph("<code>job_opportunities_screen.dart</code>", body_style)],
        [Paragraph("<b>P14</b>", body_style), Paragraph("State Management (ChangeNotifier, InheritedNotifier)", body_style), Paragraph("<code>craft_store_provider.dart</code>", body_style)],
        [Paragraph("<b>P15 & P16</b>", body_style), Paragraph("Data Modeling & JSON Parsing (fromJson/toJson)", body_style), Paragraph("<code>models/product_model.dart</code>", body_style)],
        [Paragraph("<b>P17 & P18</b>", body_style), Paragraph("Database (Cloud Firestore) & Auth (Firebase Auth)", body_style), Paragraph("<code>services/firebase_service.dart</code>", body_style)],
        [Paragraph("<b>P22</b>", body_style), Paragraph("Responsive & Adaptive UI (MediaQuery)", body_style), Paragraph("<code>product_catalog_screen.dart</code>", body_style)],
    ]

    t_syl = Table(syllabus_data, colWidths=[1.1 * inch, 3.4 * inch, 1.8 * inch])
    t_syl.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), c_primary),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0, 0), (-1, -1), 5),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
    ]))
    story.append(t_syl)

    story.append(PageBreak())

    # =========================================================================
    # 5. VIVA EXAM GUIDE & TECHNICAL Q&A
    # =========================================================================
    story.append(Paragraph("5. Viva Exam Preparation Guide & Q&A", h1_style))
    story.append(HRFlowable(width="100%", thickness=1, color=c_primary, spaceBefore=2, spaceAfter=10))

    story.append(Paragraph(
        "Below are key technical questions and answers designed for the oral Viva examination:",
        body_style
    ))

    viva_qna = [
        ("Q1: What is the main entry point and state architecture of your app?",
         "The entry point is void main() in main.dart. State management is handled via ChangeNotifier and InheritedNotifier (CraftStoreScope), which trigger reactive rebuilds using notifyListeners()."),
        
        ("Q2: How does your profit sharing algorithm work?",
         "The algorithm computes Net Profit = Price - RawMaterialCost, allocating 70% directly to the artisan, 15% to a community welfare fund, and 15% to a raw material pool."),
        
        ("Q3: How are Cloud Firestore and Firebase Auth integrated?",
         "FirebaseService initializes DefaultFirebaseOptions.currentPlatform, using Firestore collections ('products', 'analytics') for NoSQL storage and FirebaseAuth for user sign-in/sign-up with fallback handling."),
        
        ("Q4: How does Form validation work in your project?",
         "Forms use a GlobalKey<FormState>. Calling _formKey.currentState!.validate() triggers validator functions on every child TextFormField before executing actions."),
        
        ("Q5: Why did you use GridView.builder instead of GridView.count?",
         "GridView.builder lazily builds items as they scroll into view, drastically improving memory efficiency compared to instantiating all grid items upfront."),
    ]

    for q, a in viva_qna:
        story.append(Paragraph(f"<b>{q}</b>", ParagraphStyle('QStyle', parent=body_style, fontName='Helvetica-Bold', textColor=c_primary)))
        story.append(Paragraph(f"<i>Answer:</i> {a}", ParagraphStyle('AStyle', parent=body_style, textColor=c_dark, leftIndent=10)))
        story.append(Spacer(1, 6))

    story.append(Spacer(1, 15))
    story.append(HRFlowable(width="100%", thickness=1, color=c_accent, spaceBefore=10, spaceAfter=15))
    story.append(Paragraph("<b>End of Official Academic Project Report</b>", ParagraphStyle('EndDoc', fontName='Helvetica-Oblique', fontSize=10, alignment=1, textColor=c_muted)))

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"✅ PDF Project Report successfully created at: {filename}")

if __name__ == "__main__":
    output_path = "/Users/omsawant/Desktop/FlutterImp/CraftCulture_Project_Report.pdf"
    create_project_report_pdf(output_path)
