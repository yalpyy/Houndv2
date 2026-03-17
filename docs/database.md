# HOUND — Database Schema

## Overview

PostgreSQL database managed via Supabase with Row Level Security (RLS) enabled on all tables.

## Entity Relationship

```
auth.users (Supabase Auth)
    │
    └── profiles (1:1)
          │
          ├── applications_waitlist (1:1)
          │
          ├── dogs (1:1, one dog per user)
          │     ├── dog_traits (1:1)
          │     ├── dog_photos (1:many)
          │     └── dog_verification_docs (1:many)
          │
          ├── intro_requests (as sender or receiver)
          │     └── chat_threads (1:1, created on accept)
          │           └── chat_messages (1:many)
          │
          └── walk_proposals (as proposer or receiver)

circles (standalone reference table)
```

## Enums

| Enum | Values |
|------|--------|
| `application_status` | pending, in_review, approved, rejected |
| `dog_verification_status` | not_submitted, pending, approved, rejected |
| `dog_gender` | male, female |
| `intro_request_status` | pending, accepted, rejected, expired |
| `walk_proposal_status` | pending, accepted, rejected, cancelled, completed |
| `walk_time_of_day` | morning, noon, evening, sunset |
| `membership_tier` | standard, premium, elite |

## Tables

### profiles
- **Primary key:** `id` (UUID, references auth.users)
- **Fields:** full_name, email, avatar_url, city, circle, bio, referral_code (unique, auto-generated), referred_by, application_status, membership_tier, is_verified
- **Triggers:** Auto-create on auth.users insert, auto-generate referral code, auto-update updated_at
- **RLS:** Users can view/update own profile; approved users can view other profiles

### applications_waitlist
- **Primary key:** `id` (UUID)
- **Foreign keys:** user_id → profiles
- **Fields:** reference_number (unique, auto-generated as HND-XXXX), full_name, city, circle, referral_code_used, dog info fields, lifestyle_notes, how_heard, status, admin_notes, reviewed_by, reviewed_at
- **Triggers:** Auto-generate reference number, sync approval to profiles table

### circles
- **Primary key:** `id` (UUID)
- **Fields:** name, city, description, latitude, longitude, radius_km, is_active
- **Seeded data:** Holland Park, Kensington Gardens, Chelsea, Bebek Sahil, Maçka Parkı

### dogs
- **Primary key:** `id` (UUID)
- **Foreign keys:** owner_id → profiles (UNIQUE — one dog per user), circle_id → circles
- **Fields:** name, breed, age, gender, weight_kg, bio, favorite_activity, verification_status, photo_urls
- **Triggers:** Reset verification to pending when critical info (name, breed, age, gender) changes

### dog_traits
- **Primary key:** `id` (UUID)
- **Foreign keys:** dog_id → dogs (UNIQUE — one-to-one)
- **Fields:** energy, sociability, adaptability, trainability, playfulness (all 0-100 with CHECK constraints)

### dog_photos
- **Primary key:** `id` (UUID)
- **Foreign keys:** dog_id → dogs
- **Fields:** url, is_primary, sort_order

### dog_verification_docs
- **Primary key:** `id` (UUID)
- **Foreign keys:** dog_id → dogs
- **Fields:** doc_type (passport/vaccination/other), file_url, file_name, status, admin_notes

### intro_requests
- **Primary key:** `id` (UUID)
- **Foreign keys:** from_user_id, to_user_id → profiles; from_dog_id, to_dog_id → dogs
- **Fields:** message, status, chat_thread_id
- **Constraint:** UNIQUE on (from_user_id, to_user_id) — no duplicate requests
- **Triggers:** On status change to 'accepted', auto-create chat_thread and link it
- **RLS:** Only approved users with verified dogs can send; receivers can update status

### chat_threads
- **Primary key:** `id` (UUID)
- **Foreign keys:** intro_request_id → intro_requests (UNIQUE), participant_1_id, participant_2_id → profiles
- **Fields:** last_message, last_message_at, is_active
- **Realtime:** Not directly subscribed (subscribe to chat_messages instead)

### chat_messages
- **Primary key:** `id` (UUID)
- **Foreign keys:** thread_id → chat_threads, sender_id → profiles
- **Fields:** content, image_url, is_read
- **Triggers:** Auto-update chat_thread.last_message on insert
- **Realtime:** Added to `supabase_realtime` publication for live subscriptions

### walk_proposals
- **Primary key:** `id` (UUID)
- **Foreign keys:** proposer_user_id, receiver_user_id → profiles; chat_thread_id → chat_threads
- **Fields:** proposed_date, time_of_day, circle_name, location_note, note, status

## Storage Buckets

| Bucket | Public | Purpose |
|--------|--------|---------|
| `dog-photos` | Yes | Dog profile photos |
| `verification-docs` | No | Passport, vaccination records |
| `avatars` | Yes | User profile pictures |

## Key Indexes

All foreign keys are indexed. Additional indexes on:
- `profiles.application_status`, `profiles.referral_code`, `profiles.city`
- `dogs.verification_status`, `dogs.circle_id`
- `chat_messages.thread_id`, `chat_messages.created_at`
- `walk_proposals.proposed_date`, `walk_proposals.status`
