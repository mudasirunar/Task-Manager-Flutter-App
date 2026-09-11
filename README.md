# Task Manager App

---

## 📱 Features

- **Task Creation**: Add new tasks with mandatory titles and optional multi-line descriptions.
- **Strict Validation**: Rejects empty strings and whitespace-only titles with clear, actionable error feedback.
- **Task Editing**: Seamlessly modify existing tasks; all changes persist across application restarts.
- **Status Toggle**: Instant one-tap status toggling between **Pending** and **Completed**.
- **All / Pending / Completed Filters**: Dynamic filter chips with live task counters for instant clarity.
- **Safe Deletion Flow**: Explicit confirmation dialog before any task is removed (Cancel safely preserves the task; Confirm deletes permanently).
- **Persistent Local Storage**: Full offline data persistence across app cold boots.
- **Contextual Empty States**: Distinct visual states when no tasks exist vs when an active filter yields no matches.
- **Responsive & Overflow-Proof**: Built with adaptive layouts (`SafeArea`, `SingleChildScrollView`, `LayoutBuilder`) to ensure zero `RenderFlex overflowed` errors across small screens, large screens, landscape orientation, and active keyboard entry.
- **Calm, Professional UI**: A tailored, modern Material 3 design system with soft slate tones, emerald completed indicators, amber pending indicators, and subtle diffused shadows — free of over-saturated neon effects.

---

## 🏛 Architecture: Clean Architecture

The project strictly follows Uncle Bob's **Clean Architecture** to maintain clean boundaries, testability, and separation of concerns:

```
lib/
├── core/                         # Cross-cutting concerns & shared foundations
│   ├── constants/                # App colors, typography dimensions, strings
│   ├── theme/                    # Material 3 Theme configurations
│   └── utils/                    # Validators and date formatters
├── domain/                       # Core business logic (Pure Dart, zero framework dependencies)
│   ├── entities/                 # TaskEntity, TaskFilter enum
│   └── repositories/             # Abstract TaskRepository interface
├── data/                         # Implementation of domain contracts & external data sources
│   ├── datasources/              # TaskLocalDataSource contract & SharedPreferences implementation
│   ├── models/                   # TaskModel with JSON serialization (fromJson / toJson)
│   └── repositories/             # TaskRepositoryImpl bridging data sources to domain
└── presentation/                 # User interface & reactive state management
    ├── controllers/              # TaskController (ChangeNotifier)
    ├── screens/                  # SplashScreen, HomeScreen, TaskFormScreen
    └── widgets/                  # Reusable components (TaskCard, FilterChips, Buttons, Dialogs)
```

---

## ⚡ State Management & Local Storage

### State Management: `ChangeNotifier` + `ListenableBuilder`
- Built entirely with Flutter's native reactive primitives (`ChangeNotifier` and `ListenableBuilder`).
- **Why this approach?**:
  - Zero heavy third-party dependencies, guaranteeing long-term stability and compatibility.
  - Granular widget rebuilds (only parts of the UI listening to state changes are rebuilt).
  - Clean separation: presentation widgets invoke controller methods without knowing anything about storage mechanics.

### Local Storage: `shared_preferences` with JSON Document Serialization
- Storage operations are abstracted behind a domain repository interface (`TaskRepository`).
- The `TaskSharedPrefsDataSource` serializes task models into structured JSON strings and saves them locally.
- **Why this approach?**:
  - Official Flutter Favorite package: ultra-stable, zero native C++ build complications, cross-platform.
  - Decoupled by contract: if requirements evolve to SQLite or Hive in the future, only the data source implementation needs to be swapped—domain and UI code remain untouched.

---

## 🛠 Tech Stack & Packages

| Package | Version | Purpose |
|---|---|---|
| **Flutter** | `3.44.6` (Channel stable) | Core framework |
| **Dart** | `3.12.2` | Programming language |
| **shared_preferences** | `^2.3.5` | Atomic local data persistence |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version `>= 3.44.0`).
- Dart SDK installed (version `>= 3.12.0`).
- Android Studio / VS Code / Xcode configured for Flutter development.

### Setup & Run
1. **Clone the repository:**
   ```bash
   git clone https://github.com/mudasirunar/Task-Manager-Flutter-App.git
   cd Task-Manager-Flutter-App
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run static analysis:**
   ```bash
   flutter analyze
   ```

4. **Launch the application:**
   ```bash
   flutter run
   ```

### Building the Release APK (Android)
```bash
flutter build apk --release
```
The installable APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📋 Acceptance Checks Verification Matrix

| Check | Scenario | Expected Behavior | Status |
|---|---|---|---|
| **1** | Add 2 tasks, edit 1, restart app | Both tasks exist; edited task retains updated content across cold restart | Verified |
| **2** | Mark task as completed | Instant status badge update; "All", "Pending", and "Completed" filters reflect accurately | Verified |
| **3** | Deletion confirmation | "Cancel" dismisses without deleting; "Delete" removes item from list and persistence | Verified |
| **4** | Input validation | Empty title or spaces-only (`"   "`) displays error banner and blocks creation | Verified |
| **5** | Keyboard & small screen layout | Screen auto-scrolls when keyboard opens; zero `RenderFlex overflowed` warnings | Verified |
| **6** | Orientation adaptability | UI dynamically adapts to both Portrait and Landscape orientations | Verified |

---

## ⚠️ Known Limitations
- Designed as a lightweight, single-user offline task manager; multi-user synchronization and cloud backend sync are intentionally out of scope per assignment guidelines.
- Media attachments and subtasks are not included to preserve simplicity and adhere strictly to the assessment specification.
