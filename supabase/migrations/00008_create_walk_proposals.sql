-- HOUND Database Schema - Walk Proposals
-- Migration: 00008_create_walk_proposals

CREATE TABLE walk_proposals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proposer_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  receiver_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  chat_thread_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
  proposed_date DATE NOT NULL,
  time_of_day walk_time_of_day NOT NULL DEFAULT 'morning',
  circle_name TEXT,
  location_note TEXT,
  note TEXT,
  status walk_proposal_status NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trigger_walk_proposals_updated_at
  BEFORE UPDATE ON walk_proposals
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Indexes
CREATE INDEX idx_walk_proposals_proposer ON walk_proposals(proposer_user_id);
CREATE INDEX idx_walk_proposals_receiver ON walk_proposals(receiver_user_id);
CREATE INDEX idx_walk_proposals_thread ON walk_proposals(chat_thread_id);
CREATE INDEX idx_walk_proposals_date ON walk_proposals(proposed_date);
CREATE INDEX idx_walk_proposals_status ON walk_proposals(status);

-- RLS
ALTER TABLE walk_proposals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own walk proposals"
  ON walk_proposals FOR SELECT
  USING (auth.uid() = proposer_user_id OR auth.uid() = receiver_user_id);

CREATE POLICY "Users can create walk proposals in own threads"
  ON walk_proposals FOR INSERT
  WITH CHECK (
    auth.uid() = proposer_user_id
    AND EXISTS (
      SELECT 1 FROM chat_threads ct
      WHERE ct.id = chat_thread_id
      AND (ct.participant_1_id = auth.uid() OR ct.participant_2_id = auth.uid())
    )
  );

CREATE POLICY "Receivers can update walk proposals"
  ON walk_proposals FOR UPDATE
  USING (auth.uid() = receiver_user_id);
