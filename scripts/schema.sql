-- Function to check if a table exists
CREATE OR REPLACE FUNCTION check_table_exists(p_table_name text)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public'
      AND table_name = p_table_name
  );
END;
$$ LANGUAGE plpgsql;

-- Function to create the user_profiles table
CREATE OR REPLACE FUNCTION create_user_profiles_table()
RETURNS void AS $$
BEGIN
  CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    name TEXT,
    pronouns TEXT,
    phone TEXT,
    website TEXT,
    bio TEXT,
    privacy_settings JSONB DEFAULT '{"email": false, "name": false, "pronouns": false, "phone": false, "website": false, "bio": false}'::JSONB
  );
END;
$$ LANGUAGE plpgsql;

-- Function to update the user_profiles table
CREATE OR REPLACE FUNCTION update_user_profiles_table()
RETURNS void AS $$
BEGIN
  -- Add new columns if they don't exist
  ALTER TABLE public.user_profiles
    ADD COLUMN IF NOT EXISTS name TEXT,
    ADD COLUMN IF NOT EXISTS pronouns TEXT,
    ADD COLUMN IF NOT EXISTS phone TEXT,
    ADD COLUMN IF NOT EXISTS website TEXT,
    ADD COLUMN IF NOT EXISTS bio TEXT,
    ADD COLUMN IF NOT EXISTS privacy_settings JSONB DEFAULT '{"email": false, "name": false, "pronouns": false, "phone": false, "website": false, "bio": false}'::JSONB;
END;
$$ LANGUAGE plpgsql;

-- Execute the functions to create or update the table
DO $$
BEGIN
  IF NOT check_table_exists('user_profiles') THEN
    PERFORM create_user_profiles_table();
    RAISE NOTICE 'Created user_profiles table.';
  ELSE
    PERFORM update_user_profiles_table();
    RAISE NOTICE 'Updated user_profiles table.';
  END IF;
END $$;