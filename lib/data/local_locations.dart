const List<Map<String, dynamic>> localLocations = [
  // --- TÜRKIYE 🇹🇷 (ALL 81 PROVINCES) ---
  {'name': 'Adana', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.0, 'lon': 35.3213},
  {'name': 'Adıyaman', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.7644, 'lon': 38.2763},
  {'name': 'Afyonkarahisar', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.7569, 'lon': 30.5387},
  {'name': 'Ağrı', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.7191, 'lon': 43.0503},
  {'name': 'Amasya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.6533, 'lon': 35.8331},
  {'name': 'Ankara', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.9334, 'lon': 32.8597},
  {'name': 'Antalya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 36.8841, 'lon': 30.7056},
  {'name': 'Artvin', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.1828, 'lon': 41.8183},
  {'name': 'Aydın', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.8444, 'lon': 27.8458},
  {'name': 'Balıkesir', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.6484, 'lon': 27.8826},
  {'name': 'Bilecik', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.1419, 'lon': 29.9793},
  {'name': 'Bingöl', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.8847, 'lon': 40.4939},
  {'name': 'Bitlis', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.4006, 'lon': 42.1095},
  {'name': 'Bolu', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.7325, 'lon': 31.6082},
  {'name': 'Burdur', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.7204, 'lon': 30.2908},
  {'name': 'Bursa', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.1885, 'lon': 29.061},
  {'name': 'Çanakkale', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.1467, 'lon': 26.4086},
  {'name': 'Çankırı', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.6013, 'lon': 33.6134},
  {'name': 'Çorum', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.5489, 'lon': 34.9533},
  {'name': 'Denizli', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.7765, 'lon': 29.0864},
  {'name': 'Diyarbakır', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.9144, 'lon': 40.211},
  {'name': 'Edirne', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.6771, 'lon': 26.5592},
  {'name': 'Elazığ', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.6748, 'lon': 39.2225},
  {'name': 'Erzincan', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.7468, 'lon': 39.4912},
  {'name': 'Erzurum', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.9000, 'lon': 41.2700},
  {'name': 'Eskişehir', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.7767, 'lon': 30.5206},
  {'name': 'Gaziantep', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.0662, 'lon': 37.3833},
  {'name': 'Giresun', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.9128, 'lon': 38.3895},
  {'name': 'Gümüşhane', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.4608, 'lon': 39.4814},
  {'name': 'Hakkari', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.5744, 'lon': 43.7408},
  {'name': 'Hatay', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 36.4018, 'lon': 36.3498},
  {'name': 'Isparta', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.7648, 'lon': 30.5566},
  {'name': 'İçel (Mersin)', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 36.8121, 'lon': 34.6415},
  {'name': 'İstanbul', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.0082, 'lon': 28.9784},
  {'name': 'İzmir', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.4237, 'lon': 27.1428},
  {'name': 'Kars', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.6019, 'lon': 43.0949},
  {'name': 'Kastamonu', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.3811, 'lon': 33.7744},
  {'name': 'Kayseri', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.7312, 'lon': 35.4787},
  {'name': 'Kırklareli', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.7333, 'lon': 27.2167},
  {'name': 'Kırşehir', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.1425, 'lon': 34.1709},
  {'name': 'Kocaeli', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.8533, 'lon': 29.8815},
  {'name': 'Konya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.8714, 'lon': 32.4846},
  {'name': 'Kütahya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.4167, 'lon': 29.9833},
  {'name': 'Malatya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.3552, 'lon': 38.3095},
  {'name': 'Manisa', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.6191, 'lon': 27.4289},
  {'name': 'Kahramanmaraş', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.5858, 'lon': 36.9371},
  {'name': 'Mardin', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.3122, 'lon': 40.735},
  {'name': 'Muğla', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.2153, 'lon': 28.3636},
  {'name': 'Muş', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.7339, 'lon': 41.4911},
  {'name': 'Nevşehir', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.6244, 'lon': 34.7144},
  {'name': 'Niğde', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.9667, 'lon': 34.6833},
  {'name': 'Ordu', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.9839, 'lon': 37.8764},
  {'name': 'Rize', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.0201, 'lon': 40.5234},
  {'name': 'Sakarya', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.7569, 'lon': 30.3781},
  {'name': 'Samsun', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.2867, 'lon': 36.33},
  {'name': 'Siirt', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.9274, 'lon': 41.9403},
  {'name': 'Sinop', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 42.0231, 'lon': 35.1531},
  {'name': 'Sivas', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.7477, 'lon': 37.0179},
  {'name': 'Tekirdağ', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.9781, 'lon': 27.511},
  {'name': 'Tokat', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.3139, 'lon': 36.5544},
  {'name': 'Trabzon', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.0027, 'lon': 39.7168},
  {'name': 'Tunceli', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.1079, 'lon': 39.5403},
  {'name': 'Şanlıurfa', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.1674, 'lon': 38.7955},
  {'name': 'Uşak', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.6823, 'lon': 29.4082},
  {'name': 'Van', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.4891, 'lon': 43.4089},
  {'name': 'Yozgat', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.8181, 'lon': 34.8147},
  {'name': 'Zonguldak', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.4511, 'lon': 31.7944},
  {'name': 'Aksaray', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 38.3687, 'lon': 34.037},
  {'name': 'Bayburt', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.2552, 'lon': 40.2249},
  {'name': 'Karaman', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.1759, 'lon': 33.2214},
  {'name': 'Kırıkkale', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.8468, 'lon': 33.5153},
  {'name': 'Batman', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.8874, 'lon': 41.1322},
  {'name': 'Şırnak', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.5164, 'lon': 42.4611},
  {'name': 'Bartın', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.6344, 'lon': 32.3375},
  {'name': 'Ardahan', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.1105, 'lon': 42.7022},
  {'name': 'Iğdır', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 39.9167, 'lon': 44.0333},
  {'name': 'Yalova', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.6551, 'lon': 29.2769},
  {'name': 'Karabük', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 41.2061, 'lon': 32.6204},
  {'name': 'Kilis', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 36.7184, 'lon': 37.1212},
  {'name': 'Osmaniye', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 37.0741, 'lon': 36.2473},
  {'name': 'Düzce', 'country': 'Türkiye', 'flag': '🇹🇷', 'lat': 40.8413, 'lon': 31.1581},

  // --- SUUDİ ARABİSTAN 🇸🇦 ---
  {'name': 'Mekke', 'country': 'Suudi Arabistan', 'flag': '🇸🇦', 'lat': 21.4225, 'lon': 39.8261},
  {'name': 'Medine', 'country': 'Suudi Arabistan', 'flag': '🇸🇦', 'lat': 24.4672, 'lon': 39.6024},
  {'name': 'Riyad', 'country': 'Suudi Arabistan', 'flag': '🇸🇦', 'lat': 24.7136, 'lon': 46.6753},
  {'name': 'Cidde', 'country': 'Suudi Arabistan', 'flag': '🇸🇦', 'lat': 21.4858, 'lon': 39.1925},
  
  // --- PAKİSTAN 🇵🇰 ---
  {'name': 'İslamabad', 'country': 'Pakistan', 'flag': '🇵🇰', 'lat': 33.6844, 'lon': 73.0479},
  {'name': 'Karaçi', 'country': 'Pakistan', 'flag': '🇵🇰', 'lat': 24.8607, 'lon': 67.0011},
  {'name': 'Lahor', 'country': 'Pakistan', 'flag': '🇵🇰', 'lat': 31.5204, 'lon': 74.3587},

  // --- ENDONEZYA 🇮🇩 ---
  {'name': 'Cakarta', 'country': 'Endonezya', 'flag': '🇮🇩', 'lat': -6.2088, 'lon': 106.8456},
  {'name': 'Surabaya', 'country': 'Endonezya', 'flag': '🇮🇩', 'lat': -7.2575, 'lon': 112.7521},

  // --- MALEZYA 🇲🇾 ---
  {'name': 'Kuala Lumpur', 'country': 'Malezya', 'flag': '🇲🇾', 'lat': 3.1390, 'lon': 101.6869},
  {'name': 'Johor Bahru', 'country': 'Malezya', 'flag': '🇲🇾', 'lat': 1.4927, 'lon': 103.7414},

  // --- İRAN 🇮🇷 ---
  {'name': 'Tahran', 'country': 'İran', 'flag': '🇮🇷', 'lat': 35.6892, 'lon': 51.3890},
  {'name': 'Meşhed', 'country': 'İran', 'flag': '🇮🇷', 'lat': 36.2972, 'lon': 59.6067},

  // --- IRAK 🇮🇶 ---
  {'name': 'Bağdat', 'country': 'Irak', 'flag': '🇮🇶', 'lat': 33.3152, 'lon': 44.3661},
  {'name': 'Erbil', 'country': 'Irak', 'flag': '🇮🇶', 'lat': 36.1901, 'lon': 44.0094},

  // --- AFGANİSTAN 🇦🇫 ---
  {'name': 'Kabil', 'country': 'Afganistan', 'flag': '🇦🇫', 'lat': 34.5553, 'lon': 69.1771},

  // --- ÖZBEKİSTAN 🇺🇿 ---
  {'name': 'Taşkent', 'country': 'Özbekistan', 'flag': '🇺🇿', 'lat': 41.2995, 'lon': 69.2401},
  {'name': 'Semerkant', 'country': 'Özbekistan', 'flag': '🇺🇿', 'lat': 39.6270, 'lon': 66.9750},

  // --- KAZAKİSTAN 🇰🇿 ---
  {'name': 'Astana', 'country': 'Kazakistan', 'flag': '🇰🇿', 'lat': 51.1605, 'lon': 71.4272},
  {'name': 'Almatı', 'country': 'Kazakistan', 'flag': '🇰🇿', 'lat': 43.2220, 'lon': 76.8512},

  // --- BİRLEŞİK ARAP EMİRLİKLERİ 🇦🇪 ---
  {'name': 'Dubai', 'country': 'BAE', 'flag': '🇦🇪', 'lat': 25.2048, 'lon': 55.2708},
  {'name': 'Abu Dabi', 'country': 'BAE', 'flag': '🇦🇪', 'lat': 24.4539, 'lon': 54.3773},

  // --- KATAR 🇶🇦 ---
  {'name': 'Doha', 'country': 'Katar', 'flag': '🇶🇦', 'lat': 25.2854, 'lon': 51.5310},

  // --- KUVEYT 🇰🇼 ---
  {'name': 'Kuveyt Şehri', 'country': 'Kuveyt', 'flag': '🇰🇼', 'lat': 29.3759, 'lon': 47.9774},

  // --- FAS 🇲🇦 ---
  {'name': 'Kazablanka', 'country': 'Fas', 'flag': '🇲🇦', 'lat': 33.5731, 'lon': -7.5898},
  {'name': 'Rabat', 'country': 'Fas', 'flag': '🇲🇦', 'lat': 34.0209, 'lon': -6.8416},

  // --- TUNUS 🇹🇳 ---
  {'name': 'Tunus', 'country': 'Tunus', 'flag': '🇹🇳', 'lat': 36.8065, 'lon': 10.1815},

  // --- CEZAYİR 🇩🇿 ---
  {'name': 'Cezayir', 'country': 'Cezayir', 'flag': '🇩🇿', 'lat': 36.7525, 'lon': 3.0420},

  // --- ÜRDÜN 🇯🇴 ---
  {'name': 'Amman', 'country': 'Ürdün', 'flag': '🇯🇴', 'lat': 31.9454, 'lon': 35.9284},

  // --- LÜBNAN 🇱🇧 ---
  {'name': 'Beyrut', 'country': 'Lübnan', 'flag': '🇱🇧', 'lat': 33.8938, 'lon': 35.5018},

  // --- SURİYE 🇸🇾 ---
  {'name': 'Şam', 'country': 'Suriye', 'flag': '🇸🇾', 'lat': 33.5138, 'lon': 36.2765},
  {'name': 'Halep', 'country': 'Suriye', 'flag': '🇸🇾', 'lat': 36.2021, 'lon': 37.1343},

  // --- MISIR 🇪🇬 ---
  {'name': 'Kahire', 'country': 'Mısır', 'flag': '🇪🇬', 'lat': 30.0444, 'lon': 31.2357},
  {'name': 'İskenderiye', 'country': 'Mısır', 'flag': '🇪🇬', 'lat': 31.2001, 'lon': 29.9187},

  // --- FİLİSTİN 🇵🇸 ---
  {'name': 'Kudüs', 'country': 'Filistin', 'flag': '🇵🇸', 'lat': 31.7683, 'lon': 35.2137},
  {'name': 'Gazze', 'country': 'Filistin', 'flag': '🇵🇸', 'lat': 31.5017, 'lon': 34.4668},

  // --- AZERBAYCAN 🇦🇿 ---
  {'name': 'Bakü', 'country': 'Azerbaycan', 'flag': '🇦🇿', 'lat': 40.4093, 'lon': 49.8671},
  {'name': 'Gence', 'country': 'Azerbaycan', 'flag': '🇦🇿', 'lat': 40.6828, 'lon': 46.3606},

  // --- BOSNA HERSEK 🇧🇦 ---
  {'name': 'Saraybosna', 'country': 'Bosna Hersek', 'flag': '🇧🇦', 'lat': 43.8563, 'lon': 18.4131},
  {'name': 'Mostar', 'country': 'Bosna Hersek', 'flag': '🇧🇦', 'lat': 43.3438, 'lon': 17.8078},

  // --- NİJERYA 🇳🇬 ---
  {'name': 'Abuja', 'country': 'Nijerya', 'flag': '🇳🇬', 'lat': 9.0765, 'lon': 7.3986},
  {'name': 'Lagos', 'country': 'Nijerya', 'flag': '🇳🇬', 'lat': 6.5244, 'lon': 3.3792},

  // --- BANGLADEŞ 🇧🇩 ---
  {'name': 'Dakka', 'country': 'Bangladeş', 'flag': '🇧🇩', 'lat': 23.8103, 'lon': 90.4125},

  // --- HİNDİSTAN 🇮🇳 ---
  {'name': 'Yeni Delhi', 'country': 'Hindistan', 'flag': '🇮🇳', 'lat': 28.6139, 'lon': 77.2090},
  {'name': 'Mumbai', 'country': 'Hindistan', 'flag': '🇮🇳', 'lat': 19.0760, 'lon': 72.8777},

  // --- İNGİLTERE 🇬🇧 ---
  {'name': 'Londra', 'country': 'İngiltere', 'flag': '🇬🇧', 'lat': 51.5074, 'lon': -0.1278},
  {'name': 'Manchester', 'country': 'İngiltere', 'flag': '🇬🇧', 'lat': 53.4808, 'lon': -2.2426},

  // --- FRANSA 🇫🇷 ---
  {'name': 'Paris', 'country': 'Fransa', 'flag': '🇫🇷', 'lat': 48.8566, 'lon': 2.3522},
  {'name': 'Lyon', 'country': 'Fransa', 'flag': '🇫🇷', 'lat': 45.7640, 'lon': 4.8357},

  // --- ALMANYA 🇩🇪 ---
  {'name': 'Berlin', 'country': 'Almanya', 'flag': '🇩🇪', 'lat': 52.5200, 'lon': 13.4050},
  {'name': 'Münih', 'country': 'Almanya', 'flag': '🇩🇪', 'lat': 48.1351, 'lon': 11.5820},

  // --- ABD 🇺🇸 ---
  {'name': 'Washington, D.C.', 'country': 'ABD', 'flag': '🇺🇸', 'lat': 38.9072, 'lon': -77.0369},
  {'name': 'New York', 'country': 'ABD', 'flag': '🇺🇸', 'lat': 40.7128, 'lon': -74.0060},

  // --- RUSYA 🇷🇺 ---
  {'name': 'Moskova', 'country': 'Rusya', 'flag': '🇷🇺', 'lat': 55.7558, 'lon': 37.6173},

  // --- ÇİN 🇨🇳 ---
  {'name': 'Pekin', 'country': 'Çin', 'flag': '🇨🇳', 'lat': 39.9042, 'lon': 116.4074},

  // --- JAPONYA 🇯🇵 ---
  {'name': 'Tokyo', 'country': 'Japonya', 'flag': '🇯🇵', 'lat': 35.6762, 'lon': 139.6503},

  // --- AVUSTRALYA 🇦🇺 ---
  {'name': 'Sidney', 'country': 'Avustralya', 'flag': '🇦🇺', 'lat': -33.8688, 'lon': 151.2093},

  // --- KANADA 🇨🇦 ---
  {'name': 'Toronto', 'country': 'Kanada', 'flag': '🇨🇦', 'lat': 43.6532, 'lon': -79.3832},

  // --- BREZİLYA 🇧🇷 ---
  {'name': 'Brasília', 'country': 'Brezilya', 'flag': '🇧🇷', 'lat': -15.7975, 'lon': -47.8919},
];
