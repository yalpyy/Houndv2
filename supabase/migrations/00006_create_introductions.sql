-- HOUND Database Schema - Introduction Requests
-- Migration: 00006_create_introductions

CREATE TABLE intro_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  to_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  from_dog_id UUID NOT NULL REFERENCES dogs(id) ON DELETE CASCADE,
  to_dog_id UUID NOT NULL REFERENCES dogs(id) ON DELETE CASCADE,
  message TEXT,
  status intro_request_status NOT NULL DEFAULT 'pending',
  chat_thread_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Prevent duplicate requests
  CONSTRAINT unique_intro_pair UNIQUE (from_user_id, to_user_id)
);

CREATE TRIGGER trigger_intro_requests_updated_at
  BEFORE UPDATE ON intro_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Indexes
CREATE INDEX idx_intro_from_user ON intro_requests(from_user_id);
CREATE INDEX idx_intro_to_user ON intro_requests(to_user_id);
CREATE INDEX idx_intro_status ON intro_requests(status);

-- RLS
ALTER TABLE intro_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own intro requests"
  ON intro_requests FOR SELECT
  USING (auth.uid() = from_user_id OR auth.uid() = to_user_id);

CREATE POLICY "Approved users with verified dogs can send intros"
  ON intro_requests FOR INSERT
  WITH CHECK (
    auth.uid() = from_user_id
    AND EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid()
      AND p.application_status = 'approved'
    )
    AND EXISTS (
      SELECT 1 FROM dogs d
      WHERE d.owner_id = auth.uid()
      AND d.verification_status = 'approved'
    )
  );

CREATE POLICY "Users can update intros they received"
  ON intro_requests FOR UPDATE
  USING (auth.uid() = to_user_id);
