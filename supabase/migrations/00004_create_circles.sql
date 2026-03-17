-- HOUND Database Schema - Circles (Neighborhoods/Communities)
-- Migration: 00004_create_circles

CREATE TABLE circles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  description TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 2.0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trigger_circles_updated_at
  BEFORE UPDATE ON circles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Indexes
CREATE INDEX idx_circles_city ON circles(city);
CREATE INDEX idx_circles_is_active ON circles(is_active);

-- RLS
ALTER TABLE circles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active circles"
  ON circles FOR SELECT
  USING (is_active = TRUE);

-- Seed some initial circles
INSERT INTO circles (name, city, description) VALUES
  ('Holland Park Circle', 'İstanbul', 'Holland Park ve çevresi'),
  ('Kensington Gardens', 'İstanbul', 'Kensington bahçeleri bölgesi'),
  ('Chelsea Circle', 'İstanbul', 'Chelsea ve çevresi'),
  ('Bebek Sahil', 'İstanbul', 'Bebek sahil yürüyüş alanı'),
  ('Maçka Parkı', 'İstanbul', 'Maçka Parkı ve çevresi');
