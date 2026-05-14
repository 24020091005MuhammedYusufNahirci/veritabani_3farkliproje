using klinik.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace klinik.Controllers
{
    public class HomeController : Controller
    {
        // MS SQL Bağlantı Cümlesi
        string connStr = "Server=.;Database=HastaneDB;Integrated Security=True;TrustServerCertificate=True;";

        // 1. KLİNİK LİSTESİ (Ana Sayfa)
        public IActionResult Index()
        {
            List<Klinik> klinikler = new List<Klinik>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Klinikler", conn);
                SqlDataReader rs = cmd.ExecuteReader();
                while (rs.Read())
                {
                    klinikler.Add(new Klinik
                    {
                        ID = Convert.ToInt32(rs["ID"]),
                        KlinikAdi = rs["KlinikAdi"].ToString(),
                        Uzmanlik = rs["Uzmanlik"].ToString(),
                        KatNo = Convert.ToInt32(rs["KatNo"])
                    });
                }
            }
            return View(klinikler);
        }

        // 2. DOKTOR SEÇİMİ
        public IActionResult Doktorlar(int clinicId)
        {
            List<Doktor> doktorlar = new List<Doktor>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Klinik adını ViewBag'e alalım
                SqlCommand cmdKlinik = new SqlCommand("SELECT KlinikAdi FROM Klinikler WHERE ID = @ID", conn);
                cmdKlinik.Parameters.AddWithValue("@ID", clinicId);
                ViewBag.KlinikAdi = cmdKlinik.ExecuteScalar()?.ToString();

                SqlCommand cmd = new SqlCommand("SELECT * FROM Doktorlar WHERE KlinikID = @KlinikID", conn);
                cmd.Parameters.AddWithValue("@KlinikID", clinicId);
                SqlDataReader rs = cmd.ExecuteReader();
                while (rs.Read())
                {
                    doktorlar.Add(new Doktor
                    {
                        ID = Convert.ToInt32(rs["ID"]),
                        AdSoyad = rs["AdSoyad"].ToString(),
                        Unvan = rs["Unvan"].ToString()
                    });
                }
            }
            return View(doktorlar);
        }

        // 3. RANDEVU ALMA FORMU
        [HttpGet]
        public IActionResult RandevuAl(int docId)
        {
            ViewBag.DocId = docId;
            return View();
        }

        [HttpPost]
        public IActionResult RandevuAl(int docId, string tcKimlik, string adSoyad, string telefon, string kanGrubu, DateTime tarih, string sikayet)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // Hasta kontrolü
                    SqlCommand cmdCheck = new SqlCommand("SELECT ID FROM Hastalar WHERE TCKimlik = @TC", conn, trans);
                    cmdCheck.Parameters.AddWithValue("@TC", tcKimlik);
                    object hastaIdObj = cmdCheck.ExecuteScalar();
                    int hastaId = 0;

                    if (hastaIdObj == null)
                    {
                        SqlCommand cmdInsertHasta = new SqlCommand(
                            "INSERT INTO Hastalar (TCKimlik, AdSoyad, Telefon, KanGrubu) VALUES (@TC, @Ad, @Tel, @Kan); SELECT SCOPE_IDENTITY();", conn, trans);
                        cmdInsertHasta.Parameters.AddWithValue("@TC", tcKimlik);
                        cmdInsertHasta.Parameters.AddWithValue("@Ad", adSoyad);
                        cmdInsertHasta.Parameters.AddWithValue("@Tel", telefon);
                        cmdInsertHasta.Parameters.AddWithValue("@Kan", kanGrubu);
                        hastaId = Convert.ToInt32(cmdInsertHasta.ExecuteScalar());
                    }
                    else { hastaId = Convert.ToInt32(hastaIdObj); }

                    // Randevu Kaydı
                    SqlCommand cmdRandevu = new SqlCommand(
                        "INSERT INTO Randevular (HastaID, DoktorID, RandevuTarihi, Sikayet) VALUES (@HastaID, @DocID, @Tarih, @Sikayet)", conn, trans);
                    cmdRandevu.Parameters.AddWithValue("@HastaID", hastaId);
                    cmdRandevu.Parameters.AddWithValue("@DocID", docId);
                    cmdRandevu.Parameters.AddWithValue("@Tarih", tarih);
                    cmdRandevu.Parameters.AddWithValue("@Sikayet", sikayet);
                    cmdRandevu.ExecuteNonQuery();

                    trans.Commit();
                    return RedirectToAction("HastaGecmisi", new { tcAranan = tcKimlik });
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ViewBag.Hata = "Kayıt Başarısız: " + ex.Message;
                    ViewBag.DocId = docId;
                    return View();
                }
            }
        }

        // 4. HASTA GEÇMİŞİ
        public IActionResult HastaGecmisi(string tcAranan)
        {
            List<RandevuGecmisi> gecmis = new List<RandevuGecmisi>();
            ViewBag.TC = tcAranan;

            if (!string.IsNullOrEmpty(tcAranan))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"SELECT r.RandevuTarihi, r.Sikayet, d.AdSoyad AS DoktorAdi, d.Unvan, k.KlinikAdi, 
                                     rec.IlacListesi, rec.KullanimTalimati 
                                     FROM Randevular r
                                     JOIN Doktorlar d ON r.DoktorID = d.ID
                                     JOIN Klinikler k ON d.KlinikID = k.ID
                                     JOIN Hastalar h ON r.HastaID = h.ID
                                     LEFT JOIN Receteler rec ON r.ID = rec.RandevuID
                                     WHERE h.TCKimlik = @TC ORDER BY r.RandevuTarihi DESC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@TC", tcAranan);
                    SqlDataReader rs = cmd.ExecuteReader();
                    while (rs.Read())
                    {
                        gecmis.Add(new RandevuGecmisi
                        {
                            RandevuTarihi = Convert.ToDateTime(rs["RandevuTarihi"]),
                            KlinikAdi = rs["KlinikAdi"].ToString(),
                            DoktorAdi = rs["Unvan"].ToString() + " " + rs["DoktorAdi"].ToString(),
                            Sikayet = rs["Sikayet"].ToString(),
                            IlacListesi = rs["IlacListesi"] != DBNull.Value ? rs["IlacListesi"].ToString() : null,
                            KullanimTalimati = rs["KullanimTalimati"] != DBNull.Value ? rs["KullanimTalimati"].ToString() : null
                        });
                    }
                }
            }
            return View(gecmis);
        }

        // 5. GÜNLÜK PLAN
        public IActionResult GunlukPlan(int? seciliDoktor)
        {
            // Doktor Listesi Dropdown için
            List<Doktor> doktorlar = new List<Doktor>();
            List<GunlukPlanModel> plan = new List<GunlukPlanModel>();
            ViewBag.SeciliDoktor = seciliDoktor;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmdDoc = new SqlCommand("SELECT ID, Unvan, AdSoyad FROM Doktorlar", conn);
                SqlDataReader rsDoc = cmdDoc.ExecuteReader();
                while (rsDoc.Read())
                {
                    doktorlar.Add(new Doktor { ID = Convert.ToInt32(rsDoc["ID"]), AdSoyad = rsDoc["Unvan"] + " " + rsDoc["AdSoyad"] });
                }
                rsDoc.Close();
                ViewBag.Doktorlar = doktorlar;

                if (seciliDoktor.HasValue)
                {
                    string query = @"SELECT h.TCKimlik, h.AdSoyad, h.KanGrubu, r.RandevuTarihi, r.Sikayet 
                                     FROM Randevular r JOIN Hastalar h ON r.HastaID = h.ID
                                     WHERE r.DoktorID = @DocID AND CAST(r.RandevuTarihi AS DATE) = CAST(GETDATE() AS DATE)
                                     ORDER BY r.RandevuTarihi ASC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@DocID", seciliDoktor.Value);
                    SqlDataReader rs = cmd.ExecuteReader();
                    while (rs.Read())
                    {
                        plan.Add(new GunlukPlanModel
                        {
                            RandevuTarihi = Convert.ToDateTime(rs["RandevuTarihi"]),
                            TCKimlik = rs["TCKimlik"].ToString(),
                            HastaAdi = rs["AdSoyad"].ToString(),
                            KanGrubu = rs["KanGrubu"].ToString(),
                            Sikayet = rs["Sikayet"].ToString()
                        });
                    }
                }
            }
            return View(plan);
        }
    }
}