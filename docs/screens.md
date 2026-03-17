# HOUND — Screen Inventory & Flows

## Screen Map

| # | Screen | Route | File | Stitch Reference |
|---|--------|-------|------|-----------------|
| 1 | Splash | `/` | `features/splash/splash_screen.dart` | splash_screen.html |
| 2 | Welcome | `/welcome` | `features/welcome/welcome_screen.dart` | welcome_screen.html |
| 3 | Login | `/login` | `features/auth/login_screen.dart` | (inferred) |
| 4 | Application | `/application` | `features/auth/application_screen.dart` | application_step_1.html |
| 5 | Waitlist | `/waitlist` | `features/waitlist/waitlist_screen.dart` | waitlist_status.html |
| 6 | Approved | `/approved` | `features/onboarding/approved_screen.dart` | approved_welcome_step.png |
| 7 | Add Dog | `/add-dog` | `features/onboarding/add_dog_screen.dart` | edit_dog_profile.html (create mode) |
| 8 | Edit Dog | `/edit-dog/:dogId` | `features/dog_profile/edit_dog_screen.dart` | edit_dog_profile.html |
| 9 | Discovery | `/discover` | `features/discovery/discovery_screen.dart` | discovery_home.html |
| 10 | Discovery Locked | `/discover/locked` | `features/discovery/discovery_locked_screen.dart` | discovery_locked.html |
| 11 | Dog Detail | `/dog/:dogId` | `features/dog_profile/dog_profile_detail_screen.dart` | dog_profile_detail.html |
| 12 | Requests Inbox | `/requests` | `features/requests/requests_inbox_screen.dart` | requests_inbox.html |
| 13 | Chat | `/chat/:threadId` | `features/chat/chat_screen.dart` | Chat_Screen.html |
| 14 | Walk Planning | `/walk-plan/:threadId` | `features/walk_planning/walk_planning_screen.dart` | plan_a_walk.html |
| 15 | Owner Profile | `/profile` | `features/owner_profile/owner_profile_screen.dart` | owner_profile.html |
| 16 | Settings | `/settings` | `features/settings/settings_screen.dart` | (inferred) |
| 17 | Premium | `/premium` | `features/premium/premium_screen.dart` | (inferred) |

## Navigation Flow

### Onboarding Flow
```
Splash → Welcome → [Login | Application]
                         ↓
                    Waitlist (İncelemede)
                         ↓ (admin approval)
                    Approved
                         ↓
                    Add Dog (Köpek Ekle)
                         ↓ (submit for review)
                    Discovery (or Discovery Locked if dog under review)
```

### Main App (Bottom Navigation)
```
┌─────────────────────────────────────┐
│  KEŞFET  │  İSTEKLER  │  PROFİL    │
└─────────────────────────────────────┘
     ↓           ↓            ↓
  Discovery   Requests    Owner Profile
     ↓           ↓            ↓
  Dog Detail   Chat      Edit Dog
     ↓           ↓         Settings
  Send Intro  Walk Plan    Premium
```

### Chat Flow
```
Requests Inbox → Accept Intro → "Mesaj Gönder" → Chat Screen
                                                     ↓
                                               Walk Planning
```

## Special UI Rules

### Waitlist Screen
- **NO** "Support" or "View Application" buttons
- Show reference number and referral code
- Pulsing amber dot for "İncelemede" status

### Dog Profile Detail
- Owner avatar + name must appear ABOVE the map area
- Show personality traits as circular progress indicators
- Floating "TANIŞMA İSTEĞİ GÖNDER" CTA at bottom

### Add Dog / Edit Dog
- Personality traits must include BOTH slider controls AND numeric percentage inputs (0-100)
- Verification document upload for passport and vaccination records
- Disclaimer about re-verification on critical changes

### Requests Inbox
- "Mesaj Gönder" button on accepted requests MUST navigate to actual chat screen
- Segmented tabs: Gelen (Received) / Giden (Sent)
- Status badges: BEKLEMEDE (amber), ONAYLANDI (green), REDDEDİLDİ (gray)

### Discovery
- Blocked if user has no dog → show discovery_locked screen
- Intro actions disabled if dog is under review
- Card shows: verified badge, name+age, location, trait chips, bio

### Owner Profile
- Must show referral code with copy functionality
- "Düzenle" button on dog card must navigate to edit dog page

### Chat
- Premium editorial tone
- Parchment background (#F9F7F2)
- Received: champagne bubbles, Sent: navy bubbles
- "Yürüyüş Planla" action in header
- Plus Jakarta Sans for message text

## Access Control States

| State | Can Access Discovery | Can Send Intros | Can Chat |
|-------|---------------------|-----------------|----------|
| Not logged in | No | No | No |
| Application pending | No | No | No |
| Application approved, no dog | No (locked screen) | No | No |
| Dog under review | Yes (browse only) | No (disabled) | Existing chats only |
| Dog approved | Yes | Yes | Yes |
