-- HOUND Database Schema - Enums
-- Migration: 00001_create_enums

-- Application status for waitlist
CREATE TYPE application_status AS ENUM (
  'pending',
  'in_review',
  'approved',
  'rejected'
);

-- Dog verification status
CREATE TYPE dog_verification_status AS ENUM (
  'not_submitted',
  'pending',
  'approved',
  'rejected'
);

-- Dog gender
CREATE TYPE dog_gender AS ENUM (
  'male',
  'female'
);

-- Introduction request status
CREATE TYPE intro_request_status AS ENUM (
  'pending',
  'accepted',
  'rejected',
  'expired'
);

-- Walk proposal status
CREATE TYPE walk_proposal_status AS ENUM (
  'pending',
  'accepted',
  'rejected',
  'cancelled',
  'completed'
);

-- Walk time of day
CREATE TYPE walk_time_of_day AS ENUM (
  'morning',
  'noon',
  'evening',
  'sunset'
);

-- Membership tier
CREATE TYPE membership_tier AS ENUM (
  'standard',
  'premium',
  'elite'
);
