# HOUND — Özel Seçki Bir Köpek Topluluğu

HOUND is an invite-only, curated private canine society app built with Flutter and Supabase.

## Project Structure

```
Houndv2/
├── app/hound_app/              # Flutter application
│   └── lib/
│       ├── main.dart           # App entry point
│       ├── core/               # Core infrastructure
│       │   ├── constants/      # Colors, text styles, constants
│       │   ├── theme/          # App theme configuration
│       │   ├── router/         # go_router configuration
│       │   └── widgets/        # Shared reusable widgets
│       ├── features/           # Feature modules
│       │   ├── splash/         # Splash screen
│       │   ├── welcome/        # Welcome/landing screen
│       │   ├── auth/           # Login & application
│       │   ├── waitlist/       # Waitlist status screen
│       │   ├── onboarding/     # Approved + Add Dog screens
│       │   ├── discovery/      # Discovery feed + locked state
│       │   ├── dog_profile/    # Dog detail + edit screens
│       │   ├── requests/       # Intro requests inbox
│       │   ├── chat/           # Messaging screen
│       │   ├── walk_planning/  # Walk scheduling
│       │   ├── owner_profile/  # Owner profile screen
│       │   ├── settings/       # App settings
│       │   └── premium/        # Premium membership
│       ├── models/             # Data models (Profile, Dog, etc.)
│       ├── repositories/       # Supabase data access layer
│       ├── providers/          # Riverpod state providers
│       └── services/           # Service layer (Supabase client)
├── supabase/migrations/        # SQL migration files (00001-00009)
├── stitch/design-reference/    # Original Stitch HTML + PNG designs
├── docs/                       # Documentation
│   ├── database.md             # Database schema docs
│   └── screens.md              # Screen inventory and flows
├── PROJECT_PROGRESS.md         # Progress tracking
└── TODO.md                     # Remaining tasks
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | Riverpod |
| Routing | go_router |
| Backend | Supabase (Auth, Postgres, Storage, Realtime) |
| Fonts | Google Fonts (Playfair Display, Public Sans, Plus Jakarta Sans) |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0
- Supabase project (free tier works)

### 1. Clone and Install

```bash
cd app/hound_app
flutter pub get
```

### 2. Supabase Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run migrations in order from `supabase/migrations/`
3. Go to SQL Editor and run each file sequentially (00001 through 00009)

### 3. Environment Configuration

Run the app with Supabase credentials:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or create a `.env` file and use a package like `flutter_dotenv`:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 4. Run Migrations

In the Supabase SQL Editor, run each migration file in order:

```
supabase/migrations/00001_create_enums.sql
supabase/migrations/00002_create_profiles.sql
supabase/migrations/00003_create_waitlist.sql
supabase/migrations/00004_create_circles.sql
supabase/migrations/00005_create_dogs.sql
supabase/migrations/00006_create_introductions.sql
supabase/migrations/00007_create_chat.sql
supabase/migrations/00008_create_walk_proposals.sql
supabase/migrations/00009_create_storage_buckets.sql
```

Or use the Supabase CLI:

```bash
supabase db push
```

### 5. Run the App

```bash
cd app/hound_app
flutter run
```

## Core Flow

```
Splash → Welcome → Application → Waitlist (İncelemede)
  → Approved → Add Dog → Dog Verification Review
  → Discovery → Intro Request → Chat → Walk Planning
```

## Business Rules

- UI is entirely in Turkish
- One dog per user (enforced at DB level)
- Discovery is blocked until: user approved + dog profile created
- Intro actions disabled while dog is under review
- Critical dog info changes reset verification status
- Accepted intro requests automatically create chat threads
- Chat uses Supabase Realtime for live messaging
