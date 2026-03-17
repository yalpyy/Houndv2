-- HOUND Database Schema - Storage Buckets
-- Migration: 00009_create_storage_buckets

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES
  ('dog-photos', 'dog-photos', TRUE),
  ('verification-docs', 'verification-docs', FALSE),
  ('avatars', 'avatars', TRUE);

-- Dog photos bucket policies
CREATE POLICY "Anyone can view dog photos"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'dog-photos');

CREATE POLICY "Authenticated users can upload dog photos"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'dog-photos'
    AND auth.role() = 'authenticated'
  );

CREATE POLICY "Users can update own dog photos"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'dog-photos'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete own dog photos"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'dog-photos'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Verification docs bucket policies (private)
CREATE POLICY "Users can view own verification docs"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'verification-docs'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can upload own verification docs"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'verification-docs'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Avatars bucket policies
CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );
