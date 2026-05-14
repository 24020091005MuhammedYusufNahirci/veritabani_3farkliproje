CREATE DATABASE HastaneDB;


USE HastaneDB;

-- 1. Klinikler Tablosu
CREATE TABLE Klinikler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    KlinikAdi NVARCHAR(100) NOT NULL,
    KatNo INT,
    Uzmanlik NVARCHAR(150)
);

-- 2. Doktorlar Tablosu
CREATE TABLE Doktorlar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    KlinikID INT FOREIGN KEY REFERENCES Klinikler(ID) ON DELETE CASCADE,
    AdSoyad NVARCHAR(150) NOT NULL,
    Unvan NVARCHAR(50)
);

-- 3. Hastalar Tablosu
CREATE TABLE Hastalar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TCKimlik CHAR(11) UNIQUE NOT NULL,
    AdSoyad NVARCHAR(150) NOT NULL,
    Telefon NVARCHAR(15),
    KanGrubu NVARCHAR(10)
);

-- 4. Randevular Tablosu
CREATE TABLE Randevular (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    HastaID INT FOREIGN KEY REFERENCES Hastalar(ID) ON DELETE CASCADE,
    DoktorID INT FOREIGN KEY REFERENCES Doktorlar(ID) ON DELETE CASCADE,
    RandevuTarihi DATETIME NOT NULL,
    Sikayet NVARCHAR(MAX)
);

-- 5. Reçeteler Tablosu
CREATE TABLE Receteler (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RandevuID INT FOREIGN KEY REFERENCES Randevular(ID) ON DELETE CASCADE,
    IlacListesi NVARCHAR(MAX) NOT NULL,
    KullanimTalimati NVARCHAR(MAX)
);


