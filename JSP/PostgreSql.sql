-- 1. Şehirler Tablosu
CREATE TABLE Sehirler (
    ID SERIAL PRIMARY KEY,
    SehirAdi VARCHAR(100) NOT NULL,
    Bolge VARCHAR(100),
    Nufus INT
);

-- 2. Rehberler Tablosu (İlişkilerden önce bağımsız tabloları kuruyoruz)
CREATE TABLE Rehberler (
    ID SERIAL PRIMARY KEY,
    RehberAdi VARCHAR(150) NOT NULL,
    UzmanlikAlani VARCHAR(150),
    Iletisim VARCHAR(100)
);

-- 3. Şehir_Rehber_Eşleşme Tablosu (Many-to-Many İlişki)
CREATE TABLE Sehir_Rehber_Eslesme (
    ID SERIAL PRIMARY KEY,
    SehirID INT REFERENCES Sehirler(ID) ON DELETE CASCADE,
    RehberID INT REFERENCES Rehberler(ID) ON DELETE CASCADE
);

-- 4. Mekanlar Tablosu (Şehre bağlı)
CREATE TABLE Mekanlar (
    ID SERIAL PRIMARY KEY,
    SehirID INT REFERENCES Sehirler(ID) ON DELETE CASCADE,
    MekanAdi VARCHAR(150) NOT NULL,
    Aciklama TEXT,
    Tur VARCHAR(50) CHECK (Tur IN ('Müze', 'Park', 'Restoran'))
);

-- 5. Etkinlikler Tablosu (Mekana bağlı)
CREATE TABLE Etkinlikler (
    ID SERIAL PRIMARY KEY,
    MekanID INT REFERENCES Mekanlar(ID) ON DELETE CASCADE,
    EtkinlikAdi VARCHAR(150) NOT NULL,
    Tarih DATE,
    Ucret NUMERIC(10, 2)
);