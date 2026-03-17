-- HOUND Database Schema - Chat / Messaging
-- Migration: 00007_create_chat

CREATE TABLE chat_threads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  intro_request_id UUID NOT NULL REFERENCES intro_requests(id) ON DELETE CASCADE UNIQUE,
  participant_1_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  last_message TEXT,
  last_message_at TIMESTAMPTZ,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trigger_chat_threads_updated_at
  BEFORE UPDATE ON chat_threads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  image_url TEXT,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Update thread last message on new message
CREATE OR REPLACE FUNCTION update_thread_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE chat_threads
  SET last_message = NEW.content,
      last_message_at = NEW.created_at,
      updated_at = NOW()
  WHERE id = NEW.thread_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_update_thread_last_message
  AFTER INSERT ON chat_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_thread_last_message();

-- Create chat thread when intro is accepted
CREATE OR REPLACE FUNCTION handle_intro_accepted()
RETURNS TRIGGER AS $$
DECLARE
  thread_id UUID;
BEGIN
  IF NEW.status = 'accepted' AND OLD.status = 'pending' THEN
    INSERT INTO chat_threads (intro_request_id, participant_1_id, participant_2_id)
    VALUES (NEW.id, NEW.from_user_id, NEW.to_user_id)
    RETURNING id INTO thread_id;

    UPDATE intro_requests
    SET chat_thread_id = thread_id
    WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_intro_accepted
  AFTER UPDATE ON intro_requests
  FOR EACH ROW
  EXECUTE FUNCTION handle_intro_accepted();

-- Indexes
CREATE INDEX idx_chat_threads_participant_1 ON chat_threads(participant_1_id);
CREATE INDEX idx_chat_threads_participant_2 ON chat_threads(participant_2_id);
CREATE INDEX idx_chat_threads_last_message_at ON chat_threads(last_message_at DESC);
CREATE INDEX idx_chat_messages_thread_id ON chat_messages(thread_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX idx_chat_messages_sender_id ON chat_messages(sender_id);

-- RLS
ALTER TABLE chat_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own chat threads"
  ON chat_threads FOR SELECT
  USING (auth.uid() = participant_1_id OR auth.uid() = participant_2_id);

CREATE POLICY "Users can view messages in own threads"
  ON chat_messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM chat_threads ct
      WHERE ct.id = thread_id
      AND (ct.participant_1_id = auth.uid() OR ct.participant_2_id = auth.uid())
    )
  );

CREATE POLICY "Users can send messages in own threads"
  ON chat_messages FOR INSERT
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM chat_threads ct
      WHERE ct.id = thread_id
      AND (ct.participant_1_id = auth.uid() OR ct.participant_2_id = auth.uid())
      AND ct.is_active = TRUE
    )
  );

-- Enable realtime for chat messages
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;
