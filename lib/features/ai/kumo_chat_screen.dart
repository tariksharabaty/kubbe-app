// TR: KUBBE V4 Kumo Chat Screen - V1'den miras alındı
// EN: KUBBE V4 Kumo Chat Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Mesaj balonları 32dp radius olan, Indigo ve Beyaz tonlarında, akıcı bir chat arayüzü kur
// EN: Create a fluid chat interface with 32dp radius message bubbles in Indigo and White tones
// TR: Giriş animasyonu olarak Lottie 'loading' kullan
// EN: Use Lottie 'loading' for entry animation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import 'kumo_engine.dart';

/// TR: KUBBE V4 Kumo Chat Screen Sınıfı
/// EN: KUBBE V4 Kumo Chat Screen Class
/// TR: V1'deki soru-cevap mantığı modernize edildi
/// EN: Modernized V1's question-answer logic
/// TR: 32dp radius mesaj balonları ve akıcı chat arayüzü
/// EN: 32dp radius message bubbles and fluid chat interface
/// TR: Indigo ve Beyaz tonlarında modern tasarım
/// EN: Modern design in Indigo and White tones
/// TR: Lottie animasyonu ve haptic feedback
/// EN: Lottie animation and haptic feedback
/// TR: V1'den miras alınan mantık V4 estetiğiyle modernize edildi
/// EN: Logic inherited from V1 modernized with V4 aesthetics
class KumoChatScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const KumoChatScreen({super.key});

  @override
  ConsumerState<KumoChatScreen> createState() => _KumoChatScreenState();
}

// TR: Kumo Chat Screen State
// EN: Kumo Chat Screen State
class _KumoChatScreenState extends ConsumerState<KumoChatScreen>
    with TickerProviderStateMixin {
  // TR: Controllers
  // EN: Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // TR: Animation controller
  // EN: Animation controller
  late AnimationController _animationController;

  // TR: Mesaj listesi
  // EN: Message list
  final List<ChatMessage> _messages = [];

  // TR: Yükleniyor durumu
  // EN: Loading state
  bool _isLoading = false;

  // TR: Kategoriler
  // EN: Categories
  final List<KumoCategory> _categories = KumoCategory.values;

  // TR: Seçili kategori
  // EN: Selected category
  KumoCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ı başlat
    // EN: Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // TR: Karşılama mesajını ekle
    // EN: Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // TR: Karşılama mesajını ekle
  // EN: Add welcome message
  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: 'welcome',
      text:
          'Merhaba! Ben KUMO AI. Size İslami konularda yardımcı olmak için buradayım. Hangi konuda bilgi almak istersiniz?\n\n📚 **Kategoriler:**\n• Zekat\n• Namaz\n• Ahlak\n• Tarih\n• İlim',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.welcome,
    );

    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  // TR: Mesaj gönder
  // EN: Send message
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    // TR: Kullanıcı mesajını ekle
    // EN: Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      type: ChatMessageType.text,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    // TR: Mesaj alanını temizle
    // EN: Clear message field
    _messageController.clear();

    // TR: Scroll'u aşağı indir
    // EN: Scroll down
    _scrollToBottom();

    // TR: Kumo cevabı simüle et
    // EN: Simulate Kumo response
    Future.delayed(const Duration(seconds: 1), () {
      _generateKumoResponse(text);
    });
  }

  // TR: Kumo cevabı oluştur
  // EN: Generate Kumo response
  void _generateKumoResponse(String userMessage) {
    final engine = ref.read(kumoEngineProvider);
    KumoQuestion? question;

    // TR: Kategoriye göre soru ara
    // EN: Search question by category
    if (_selectedCategory != null) {
      final categoryQuestions =
          engine.getQuestionsByCategory(_selectedCategory!);
      if (categoryQuestions.isNotEmpty) {
        question =
            categoryQuestions[Random().nextInt(categoryQuestions.length)];
      }
    }

    // TR: Genel arama yap
    // EN: General search
    if (question == null) {
      final searchResults = engine.searchQuestions(userMessage);
      if (searchResults.isNotEmpty) {
        question = searchResults[Random().nextInt(searchResults.length)];
      }
    }

    // TR: Rastgele soru seç
    // EN: Select random question
    question ??= engine.getRandomQuestion();

    // TR: Cevap mesajını oluştur
    // EN: Create response message
    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '**${question.question}**\n\n${question.answer}',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.answer,
      question: question,
    );

    setState(() {
      _messages.add(responseMessage);
      _isLoading = false;
    });

    // TR: Scroll'u aşağı indir
    // EN: Scroll down
    _scrollToBottom();
  }

  // TR: Scroll'u aşağı indir
  // EN: Scroll down
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // TR: Kategori seç
  // EN: Select category
  void _selectCategory(KumoCategory category) {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _selectedCategory = category;
    });

    // TR: Kategori mesajı oluştur
    // EN: Create category message
    final categoryMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text:
          '**${category.displayName}** kategorisi seçildi. Bu konuda size nasıl yardımcı olabilirim?',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.category,
      category: category,
    );

    setState(() {
      _messages.add(categoryMessage);
    });

    // TR: Scroll'u aşağı indir
    // EN: Scroll down
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Row(
          children: [
            // TR: Kumo logo
            // EN: Kumo logo
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo,
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                  ],
                ),
                // TR: Yuvarlak köşeler
                // EN: Rounded corners
                borderRadius: BorderRadius.circular(16),
                // TR: Parlayan gölge
                // EN: Glowing shadow
                boxShadow: [
                  BoxShadow(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: Logo içeriği
              // EN: Logo content
              child: const Center(
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(width: 12),

            // TR: Kumo AI metni
            // EN: Kumo AI text
            Text(
              'KUMO AI',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
      ),

      // TR: Body
      // EN: Body
      body: Column(
        children: [
          // TR: Kategori seçimi
          // EN: Category selection
          _buildCategorySelector(),

          // TR: Mesaj listesi
          // EN: Message list
          Expanded(
            child: _buildMessageList(),
          ),

          // TR: Mesaj giriş alanı
          // EN: Message input field
          _buildMessageInput(),
        ],
      ),
    );
  }

  // TR: Kategori seçimi oluştur
  // EN: Build category selector
  Widget _buildCategorySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // TR: Kategori listesi
      // EN: Category list
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            // TR: Kategori butonu
            // EN: Category button
            child: GestureDetector(
              onTap: () => _selectCategory(category),
              // TR: Buton container
              // EN: Button container
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: _selectedCategory == category
                      ? LinearGradient(
                          colors: [
                            KubbeTheme.kubbeIndigo,
                            KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  // TR: Kenar
                  // EN: Border
                  border: _selectedCategory == category
                      ? null
                      : Border.all(
                          color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                          width: 1,
                        ),
                  // TR: Renk
                  // EN: Color
                  color:
                      _selectedCategory == category ? null : Colors.transparent,
                ),
                // TR: Kategori metni
                // EN: Category text
                child: Text(
                  category.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedCategory == category
                        ? Colors.white
                        : KubbeTheme.kubbeIndigo,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // TR: Mesaj listesi oluştur
  // EN: Build message list
  Widget _buildMessageList() {
    return Container(
      decoration: BoxDecoration(
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          ],
        ),
      ),
      // TR: Mesaj listesi
      // EN: Message list
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _messages.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _messages.length) {
            return _buildMessageBubble(_messages[index]);
          } else {
            // TR: Yükleniyor animasyonu
            // EN: Loading animation
            return _buildLoadingIndicator();
          }
        },
      ),
    );
  }

  // TR: Mesaj balonu oluştur
  // EN: Build message bubble
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // TR: Mesaj satırı
      // EN: Message row
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TR: Kullanıcı değilse avatar
          // EN: Avatar if not user
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo,
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                  ],
                ),
                // TR: Yuvarlak köşeler
                // EN: Rounded corners
                borderRadius: BorderRadius.circular(16),
              ),
              // TR: Avatar içeriği
              // EN: Avatar content
              child: const Center(
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

          // TR: Mesaj içeriği
          // EN: Message content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                // TR: Maksimum genişlik
                // EN: Maximum width
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: isUser
                    ? LinearGradient(
                        colors: [
                          KubbeTheme.kubbeIndigo,
                          KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.95),
                        ],
                      ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: Mesaj metni
              // EN: Message text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TR: Metin içeriği
                  // EN: Text content
                  Text(
                    message.text,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),

                  // TR: Soru bilgisi
                  // EN: Question info
                  if (message.question != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      // TR: Soru bilgisi container
                      // EN: Question info container
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          // TR: 16dp radius
                          // EN: 16dp radius
                          borderRadius: BorderRadius.circular(16.0),
                          // TR: Gradient arka plan
                          // EN: Gradient background
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withValues(alpha: 0.1),
                              Colors.blue.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                        // TR: Soru bilgisi metni
                        // EN: Question info text
                        child: Row(
                          children: [
                            // TR: Kategori ikonu
                            // EN: Category icon
                            const Icon(
                              Icons.category,
                              size: 16,
                              color: Colors.blue,
                            ),

                            // TR: Boşluk
                            // EN: Spacer
                            const SizedBox(width: 8),

                            // TR: Kategori metni
                            // EN: Category text
                            Text(
                              '${message.question!.category.displayName} • ${message.question!.difficulty.displayName}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // TR: Zaman damgası
                  // EN: Timestamp
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    // TR: Zaman damgası metni
                    // EN: Timestamp text
                    child: Text(
                      _formatTime(message.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TR: Kullanıcıysa avatar
          // EN: Avatar if user
          if (isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withValues(alpha: 0.3),
                    Colors.grey.withValues(alpha: 0.2),
                  ],
                ),
                // TR: Yuvarlak köşeler
                // EN: Rounded corners
                borderRadius: BorderRadius.circular(16),
              ),
              // TR: Avatar içeriği
              // EN: Avatar content
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TR: Yükleniyor göstergesi oluştur
  // EN: Build loading indicator
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      // TR: Yükleniyor satırı
      // EN: Loading row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // TR: Kumo avatar
          // EN: Kumo avatar
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo,
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                ],
              ),
              // TR: Yuvarlak köşeler
              // EN: Rounded corners
              borderRadius: BorderRadius.circular(16),
            ),
            // TR: Avatar içeriği
            // EN: Avatar content
            child: const Center(
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // TR: Yükleniyor mesajı
          // EN: Loading message
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              // TR: 32dp radius - Sy-OS standartı
              // EN: 32dp radius - Sy-OS standard
              borderRadius: BorderRadius.circular(32.0),
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
              ),
              // TR: Gölge
              // EN: Shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            // TR: Yükleniyor içeriği
            // EN: Loading content
            child: Row(
              children: [
                // TR: Lottie animasyonu
                // EN: Lottie animation
                SizedBox(
                  width: 20,
                  height: 20,
                  // TR: Lottie loading animasyonu
                  // EN: Lottie loading animation
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController
                        ..duration = composition.duration
                        ..repeat();
                    },
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12),

                // TR: Yükleniyor metni
                // EN: Loading text
                Text(
                  'KUMO düşünüyor...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TR: Mesaj giriş alanı oluştur
  // EN: Build message input
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          ],
        ),
        // TR: Üst gölge
        // EN: Top shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // TR: Mesaj giriş satırı
      // EN: Message input row
      child: Row(
        children: [
          // TR: Mesaj alanı
          // EN: Message field
          Expanded(
            // TR: TextField container
            // EN: TextField container
            child: Container(
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.95),
                  ],
                ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: TextField
              // EN: TextField
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'KUMO\'ya sor sorun...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  // TR: Kenar yok
                  // EN: No border
                  border: InputBorder.none,
                  // TR: İç padding
                  // EN: Inner padding
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                // TR: Enter tuşu ile gönder
                // EN: Send with enter key
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(width: 12),

          // TR: Gönder butonu
          // EN: Send button
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            // TR: Buton container
            // EN: Button container
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo,
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                  ],
                ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: Buton içeriği
              // EN: Button content
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Zaman formatı
  // EN: Time format
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dk önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else {
      return '${difference.inDays} gün önce';
    }
  }
}

/// TR: Chat Mesaj Modeli - V4 yeniliği
/// EN: Chat Message Model - V4 innovation
/// TR: Chat mesajı veri modeli
/// EN: Chat message data model
class ChatMessage {
  // TR: Mesaj ID'si
  // EN: Message ID
  final String id;

  // TR: Mesaj metni
  // EN: Message text
  final String text;

  // TR: Kullanıcı mı
  // EN: Is user
  final bool isUser;

  // TR: Zaman damgası
  // EN: Timestamp
  final DateTime timestamp;

  // TR: Mesaj tipi
  // EN: Message type
  final ChatMessageType type;

  // TR: Soru
  // EN: Question
  final KumoQuestion? question;

  // TR: Kategori
  // EN: Category
  final KumoCategory? category;

  // TR: Constructor
  // EN: Constructor
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.type,
    this.question,
    this.category,
  });

  // TR: To JSON
  // EN: To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'question': question?.toJson(),
      'category': category?.name,
    };
  }

  // TR: From JSON
  // EN: From JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: ChatMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatMessageType.text,
      ),
      question: json['question'] != null
          ? KumoQuestion.fromJson(json['question'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? KumoCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => KumoCategory.namaz,
            )
          : null,
    );
  }
}

/// TR: Chat Mesaj Tipi Enum - V4 yeniliği
/// EN: Chat Message Type Enum - V4 innovation
/// TR: Mesaj tipleri
/// EN: Message types
enum ChatMessageType {
  // TR: Metin
  // EN: Text
  text,

  // TR: Cevap
  // EN: Answer
  answer,

  // TR: Karşılama
  // EN: Welcome
  welcome,

  // TR: Kategori
  // EN: Category
  category,
}
