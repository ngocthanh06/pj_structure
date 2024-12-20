CREATE TABLE IF NOT EXISTS
  users (
    id UUID PRIMARY KEY,
    tel_id UUID UNIQUE,
    fullname VARCHAR(255),
    nickname VARCHAR(255),
    dob VARCHAR(10),
    email VARCHAR(255) UNIQUE,
    address VARCHAR(255),
    role_code SMALLINT CHECK (role_code IN (1, 2)),
    language_id INTEGER,
    email_verified_at TIMESTAMP,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (language_id) REFERENCES languages (id) ON DELETE CASCADE,
    FOREIGN KEY (tel_id) REFERENCES tels (id) ON DELETE CASCADE
  );