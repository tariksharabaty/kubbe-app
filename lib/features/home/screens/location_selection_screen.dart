import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/models/location_model.dart';
import '../../../core/services/location_service.dart';
import '../../../data/local_locations.dart';
import '../../../ui/widgets/pulsing_loader.dart';

// [Konum Seçim Ekranı - Location Selection Screen]
// [Premium M3 Tasarımı ve Bayrak Desteği - Premium M3 Design & Flag Support]
class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _searchResults = [];
  }

  // [Arama Algoritması - Search Algorithm]
  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    // [Fuzzy search simülasyonu - Fuzzy search simulation]
    final results = localLocations.where((loc) {
      final name = loc['name'].toString().toLowerCase();
      final country = loc['country'].toString().toLowerCase();
      final search = query.toLowerCase();
      return name.contains(search) || country.contains(search);
    }).toList();

    setState(() {
      _searchResults = results;
      _selectedCountry = null; // Arama yaparken ülke filtresini kaldır - Remove country filter while searching
    });
  }

  // [Seçim Sonrası Geri Dönüş - Return After Selection]
  Future<void> _selectCity(Map<String, dynamic> loc) async {
    final location = LocationModel(
      sehir: loc['name'],
      ulke: loc['country'],
      latitude: loc['lat'],
      longitude: loc['lon'],
      timezone: null, // [API tarafından doldurulacak - To be filled by API]
    );
    Navigator.pop(context, location);
  }

  // [Otomatik Konum Tespiti - Auto Location Detection]
  Future<void> _autoLocate() async {
    setState(() => _isLoading = true);
    try {
      final loc = await LocationService.getCurrentLocation();
      if (loc != null && mounted) {
        Navigator.pop(context, loc);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Konum tespit edilemedi. (Location could not be detected)")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (_selectedCountry != null) {
              setState(() => _selectedCountry = null);
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(PhosphorIcons.caretLeft(), color: purple),
        ),
        title: Text(
          _selectedCountry ?? "Konum Seçimi",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: purple),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _autoLocate,
            icon: Icon(Icons.my_location_rounded, color: purple),
            tooltip: "Otomatik Tespit",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(purple),
          Expanded(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                if (notification.scrollDelta != null && notification.scrollDelta!.abs() > 10) {
                  FocusScope.of(context).unfocus();
                }
                return false;
              },
              child: _isLoading 
                ? const Center(child: PulsingLoader())
                : _searchController.text.isNotEmpty 
                    ? _buildSearchResults(purple)
                    : _selectedCountry == null 
                        ? _buildCountryList(purple)
                        : _buildCityList(purple),
            ),
          ),
        ],
      ),
    );
  }

  // [Modern Arama Çubuğu - Modern Search Bar]
  Widget _buildSearchBar(Color purple) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: "Şehir veya Ülke Ara...",
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: purple),
            suffixIcon: _searchController.text.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => setState(() {
                      _searchController.clear();
                      _searchResults = [];
                    }),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  // [Ülke Listesi (Bayraklı) - Country List (with Flags)]
  Widget _buildCountryList(Color purple) {
    // [Benzersiz ülkeleri al - Get unique countries]
    final countries = localLocations.map((e) => e['country']).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final countryName = countries[index];
        final firstCity = localLocations.firstWhere((element) => element['country'] == countryName);
        return _buildSelectionTile(
          title: countryName,
          subtitle: "${localLocations.where((e) => e['country'] == countryName).length} Şehir Mevcut",
          leading: Text(firstCity['flag'], style: const TextStyle(fontSize: 28)),
          onTap: () => setState(() => _selectedCountry = countryName),
          color: purple,
        );
      },
    );
  }

  // [Şehir Listesi - City List]
  Widget _buildCityList(Color purple) {
    final cities = localLocations.where((element) => element['country'] == _selectedCountry).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return _buildSelectionTile(
          title: "${city['flag']} ${city['name']}",
          subtitle: _selectedCountry ?? '',
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: purple.withValues(alpha: 0.05), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.location_city_rounded, color: purple, size: 20),
          ),
          onTap: () => _selectCity(city),
          color: purple,
        );
      },
    );
  }

  // [Arama Sonuçları - Search Results]
  Widget _buildSearchResults(Color purple) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.smileySad(), color: Colors.grey[300], size: 64),
            const SizedBox(height: 16),
            Text("Sonuç bulunamadı", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final res = _searchResults[index];
        return _buildSelectionTile(
          title: "${res['flag']} ${res['name']}",
          subtitle: res['country'],
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: purple.withValues(alpha: 0.05), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.location_city_rounded, color: purple, size: 20),
          ),
          onTap: () => _selectCity(res),
          color: purple,
        );
      },
    );
  }

  // [Premium Seçim Karosu - Premium Selection Tile]
  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required Widget leading,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        onTap: onTap,
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17, color: const Color(0xFF2D3436)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: Icon(PhosphorIcons.caretRight(), color: Colors.grey[300], size: 18),
      ),
    );
  }
}
