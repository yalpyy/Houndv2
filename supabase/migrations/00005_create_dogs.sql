-- HOUND Database Schema - Dogs
-- Migration: 00005_create_dogs

CREATE TABLE dogs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  breed TEXT NOT NULL DEFAULT '',
  age INT NOT NULL DEFAULT 0,
  gender dog_gender NOT NULL DEFAULT 'male',
  weight_kg DOUBLE PRECISION,
  bio TEXT,
  favorite_activity TEXT,
  verification_status dog_verification_status NOT NULL DEFAULT 'not_submitted',
  photo_urls TEXT[] DEFAULT '{}',
  circle_id UUID REFERENCES circles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- One dog per user constraint
  CONSTRAINT unique_dog_per_user UNIQUE (owner_id)
);

CREATE TRIGGER trigger_dogs_updated_at
  BEFORE UPDATE ON dogs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Dog traits (one-to-one with dogs)
CREATE TABLE dog_traits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dog_id UUID NOT NULL REFERENCES dogs(id) ON DELETE CASCADE UNIQUE,
  energy INT NOT NULL DEFAULT 50 CHECK (energy >= 0 AND energy <= 100),
  sociability INT NOT NULL DEFAULT 50 CHECK (sociability >= 0 AND sociability <= 100),
  adaptability INT NOT NULL DEFAULT 50 CHECK (adaptability >= 0 AND adaptability <= 100),
  trainability INT NOT NULL DEFAULT 50 CHECK (trainability >= 0 AND trainability <= 100),
  playfulness INT NOT NULL DEFAULT 50 CHECK (playfulness >= 0 AND playfulness <= 100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trigger_dog_traits_updated_at
  BEFORE UPDATE ON dog_traits
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Dog photos (additional photos beyond photo_urls array)
CREATE TABLE dog_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dog_id UUID NOT NULL REFERENCES dogs(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Dog verification documents
CREATE TABLE dog_verification_docs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dog_id UUID NOT NULL REFERENCES dogs(id) ON DELETE CASCADE,
  doc_type TEXT NOT NULL, -- 'passport', 'vaccination', 'other'
  file_url TEXT NOT NULL,
  file_name TEXT,
  status dog_verification_status NOT NULL DEFAULT 'pending',
  admin_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trigger_verification_docs_updated_at
  BEFORE UPDATE ON dog_verification_docs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Reset verification when critical info changes
CREATE OR REPLACE FUNCTION handle_dog_critical_update()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.name != NEW.name OR OLD.breed != NEW.breed OR OLD.age != NEW.age OR OLD.gender != NEW.gender) THEN
    IF OLD.verification_status = 'approved' THEN
      NEW.verification_status := 'pending';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_dog_critical_update
  BEFORE UPDATE ON dogs
  FOR EACH ROW
  EXECUTE FUNCTION handle_dog_critical_update();

-- Indexes
CREATE INDEX idx_dogs_owner_id ON dogs(owner_id);
CREATE INDEX idx_dogs_verification_status ON dogs(verification_status);
CREATE INDEX idx_dogs_circle_id ON dogs(circle_id);
CREATE INDEX idx_dog_traits_dog_id ON dog_traits(dog_id);
CREATE INDEX idx_dog_photos_dog_id ON dog_photos(dog_id);
CREATE INDEX idx_dog_verification_docs_dog_id ON dog_verification_docs(dog_id);

-- RLS
ALTER TABLE dogs ENABLE ROW LEVEL SECURITY;
ALTER TABLE dog_traits ENABLE ROW LEVEL SECURITY;
ALTER TABLE dog_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE dog_verification_docs ENABLE ROW LEVEL SECURITY;

-- Dogs policies
CREATE POLICY "Users can view own dogs"
  ON dogs FOR SELECT
  USING (auth.uid() = owner_id);

CREATE POLICY "Approved users can view verified dogs"
  ON dogs FOR SELECT
  USING (
    verification_status = 'approved'
    AND EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid()
      AND p.application_status = 'approved'
    )
  );

CREATE POLICY "Users can insert own dogs"
  ON dogs FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own dogs"
  ON dogs FOR UPDATE
  USING (auth.uid() = owner_id);

-- Dog traits policies
CREATE POLICY "Users can manage own dog traits"
  ON dog_traits FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM dogs d WHERE d.id = dog_id AND d.owner_id = auth.uid()
    )
  );

CREATE POLICY "Approved users can view traits of verified dogs"
  ON dog_traits FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM dogs d
      WHERE d.id = dog_id
      AND d.verification_status = 'approved'
      AND EXISTS (
        SELECT 1 FROM profiles p
        WHERE p.id = auth.uid()
        AND p.application_status = 'approved'
      )
    )
  );

-- Dog photos policies
CREATE POLICY "Users can manage own dog photos"
  ON dog_photos FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM dogs d WHERE d.id = dog_id AND d.owner_id = auth.uid()
    )
  );

CREATE POLICY "Approved users can view photos of verified dogs"
  ON dog_photos FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM dogs d
      WHERE d.id = dog_id
      AND d.verification_status = 'approved'
    )
  );

-- Verification docs policies
CREATE POLICY "Users can manage own verification docs"
  ON dog_verification_docs FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM dogs d WHERE d.id = dog_id AND d.owner_id = auth.uid()
    )
  );
