-- HOUND Database Schema - Waitlist / Applications
-- Migration: 00003_create_waitlist

CREATE TABLE applications_waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reference_number TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  city TEXT,
  circle TEXT,
  referral_code_used TEXT,
  dog_name TEXT,
  dog_breed TEXT,
  dog_age INT,
  lifestyle_notes TEXT,
  how_heard TEXT,
  status application_status NOT NULL DEFAULT 'pending',
  admin_notes TEXT,
  reviewed_by UUID REFERENCES profiles(id),
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Generate reference number
CREATE OR REPLACE FUNCTION generate_reference_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.reference_number := 'HND-' || LPAD(FLOOR(RANDOM() * 9999 + 1)::TEXT, 4, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generate_reference_number
  BEFORE INSERT ON applications_waitlist
  FOR EACH ROW
  EXECUTE FUNCTION generate_reference_number();

CREATE TRIGGER trigger_waitlist_updated_at
  BEFORE UPDATE ON applications_waitlist
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- When application is approved, update profile
CREATE OR REPLACE FUNCTION handle_application_approval()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE profiles
    SET application_status = 'approved',
        updated_at = NOW()
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_application_approval
  AFTER UPDATE ON applications_waitlist
  FOR EACH ROW
  EXECUTE FUNCTION handle_application_approval();

-- Indexes
CREATE INDEX idx_waitlist_user_id ON applications_waitlist(user_id);
CREATE INDEX idx_waitlist_status ON applications_waitlist(status);

-- RLS
ALTER TABLE applications_waitlist ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own application"
  ON applications_waitlist FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own application"
  ON applications_waitlist FOR INSERT
  WITH CHECK (auth.uid() = user_id);
