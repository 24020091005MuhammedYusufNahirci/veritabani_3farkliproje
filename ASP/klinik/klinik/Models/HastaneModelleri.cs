using System;

namespace klinik.Models
{
    public class Klinik
    {
        public int ID { get; set; }
        public string KlinikAdi { get; set; }
        public string Uzmanlik { get; set; }
        public int KatNo { get; set; }
    }

    public class Doktor
    {
        public int ID { get; set; }
        public string AdSoyad { get; set; }
        public string Unvan { get; set; }
        public string KlinikAdi { get; set; }
    }

    public class RandevuGecmisi
    {
        public DateTime RandevuTarihi { get; set; }
        public string KlinikAdi { get; set; }
        public string DoktorAdi { get; set; }
        public string Sikayet { get; set; }
        public string IlacListesi { get; set; }
        public string KullanimTalimati { get; set; }
    }

    public class GunlukPlanModel
    {
        public DateTime RandevuTarihi { get; set; }
        public string TCKimlik { get; set; }
        public string HastaAdi { get; set; }
        public string KanGrubu { get; set; }
        public string Sikayet { get; set; }
    }
}