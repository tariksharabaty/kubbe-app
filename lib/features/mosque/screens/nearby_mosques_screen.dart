import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../ui/widgets/pulsing_loader.dart';
import '../../../core/services/mosque_service.dart';
import '../../../core/services/prayer_time_service.dart';
import '../../../core/models/prayer_time_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyMosquesScreen extends StatefulWidget {
  const NearbyMosquesScreen({super.key});

  @override
  State<NearbyMosquesScreen> createState() => _NearbyMosquesScreenState();
}

class _NearbyMosquesScreenState extends State<NearbyMosquesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<MosqueItem> _allMosques = []; // 100 items from API
  List<MosqueItem> _displayedMosques = []; // Incremental view
  int _currentPage = 1;
  static const int _pageSize = 25;
  
  bool _isLoading = true;
  bool _isPagingLoading = false;
  String? _error;
  PrayerTimeModel? _prayerTimes; // [Cemaat hesabı için - For congregation calculation]

  @override
  void initState() {
    super.initState();
    _fetchMosques();
    _loadPrayerTimes();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('selected_city') ?? 'Istanbul';
    final country = prefs.getString('selected_country') ?? 'Turkey';
    
    final pt = await PrayerTimeService.getPrayerTimes(
      country: country,
      city: city,
      district: '',
    );
    if (mounted) setState(() => _prayerTimes = pt);
  }

  bool _isCemaatNear() {
    if (_prayerTimes == null) return false;
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;

    final prayerList = [
      _prayerTimes!.imsak,
      _prayerTimes!.ogle,
      _prayerTimes!.ikindi,
      _prayerTimes!.aksam,
      _prayerTimes!.yatsi,
    ];

    for (var pTime in prayerList) {
      final parts = pTime.split(':');
      final pMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      
      // [45 Dakika Tolerans - 45 Min Tolerance]
      if ((currentTime - pMinutes).abs() <= 45) return true;
    }
    return false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isPagingLoading && _displayedMosques.length < _allMosques.length) {
        _loadMoreItems();
      }
    }
  }

  Future<void> _fetchMosques({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _displayedMosques = [];
    });

    try {
      final mosques = await MosqueService.getNearbyMosques(forceRefresh: forceRefresh);
      
      setState(() {
        _allMosques = mosques;
        _isLoading = false;
        if (_allMosques.isEmpty) {
          _error = "Yakınlarda cami bulunamadı veya konum alınamadı.";
        } else {
          _loadMoreItems();
        }
      });
    } catch (e) {
      setState(() {
        _error = "Gökyüzüyle bağın koptu...\nİnternet bağlantınızı kontrol edin.";
        _isLoading = false;
      });
    }
  }

  void _loadMoreItems() {
    if (_isPagingLoading) return;
    
    setState(() {
      _isPagingLoading = true;
    });

    // Simulate small RAM delay for UX smoothness
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      setState(() {
        final int startIndex = (_currentPage - 1) * _pageSize;
        
        final newItems = _allMosques.skip(startIndex).take(_pageSize).toList();
        _displayedMosques.addAll(newItems);
        
        _currentPage++;
        _isPagingLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(PhosphorIcons.caretLeft(), color: purple),
        ),
        title: Text(
          "Yakındaki Camiler",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: purple),
        ),
        actions: [
          IconButton(
            onPressed: () => _fetchMosques(forceRefresh: true),
            icon: const Icon(Icons.my_location, color: purple),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: PulsingLoader(size: 60))
          : _error != null
              ? _buildErrorWidget(purple)
              : _allMosques.isEmpty
                  ? _buildEmptyWidget(purple)
                  : _buildMosqueList(purple),
    );
  }

  Widget _buildErrorWidget(Color purple) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.wifiSlash(), size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _fetchMosques(forceRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Tekrar Dene"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(Color purple) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mosque_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("Yakınlarda cami bulunamadı.", style: GoogleFonts.outfit(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMosqueList(Color purple) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _displayedMosques.length + (_isPagingLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _displayedMosques.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: PulsingLoader(size: 30)),
          );
        }

        final mosque = _displayedMosques[index];
        final name = mosque.name;
        final lat = mosque.latitude;
        final lon = mosque.longitude;
        final distance = mosque.distance;

        String distanceStr = "";
        if (distance < 1000) {
          distanceStr = "📍 ${distance.toStringAsFixed(0)} m";
        } else {
          distanceStr = "📍 ${(distance / 1000).toStringAsFixed(1)} km";
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            children: [
              // Üst Kısım: Görsel Alan (Placeholder Mosque Icon)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(Icons.mosque, size: 64, color: purple),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            name,
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF2D3436)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                distanceStr,
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600),
                              ),
                              if (mosque.isWheelchairAccessible || mosque.isBlindAccessible) ...[
                                const SizedBox(width: 8),
                                if (mosque.isWheelchairAccessible) 
                                  const Icon(Icons.accessible_forward_rounded, size: 16, color: Colors.blue),
                                if (mosque.isBlindAccessible)
                                  const Icon(Icons.blind_rounded, size: 16, color: Colors.blue),
                              ],
                            ],
                          ),
                          if (_isCemaatNear()) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Cemaat vaktine yakın",
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Aksiyon Butonları
                    Row(
                      children: [
                        // Yol Tarifi
                        InkWell(
                          onTap: () => _openInMaps(lat, lon),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.directions_rounded, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Kaydet
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                            child: Icon(PhosphorIcons.bookmarkSimple(), color: purple, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openInMaps(double lat, double lon) async {
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
