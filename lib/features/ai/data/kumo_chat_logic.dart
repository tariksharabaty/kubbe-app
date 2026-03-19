// TR: KUBBE V4 Kumo Chat Logic - V1'den miras alındı
// EN: KUBBE V4 Kumo Chat Logic - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Kullanıcı yazdığında anahtar kelimeleri (Keyword matching) yakalayıp V1'deki o pırlanta cevapları döndüren asistan mantığını kur.
// EN: Create assistant logic that captures keywords when user writes and returns V1's diamond-like answers.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kumo_repository.dart';

/// TR: KUBBE V4 Kumo Chat Mesajı Modeli
/// EN: KUBBE V4 Kumo Chat Message Model
/// TR: Sohbet mesajını temsil eder
/// EN: Represents chat message
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class KumoChatMessage {
  // TR: Mesaj ID
  // EN: Message ID
  final String id;

  // TR: Mesaj metni
  // EN: Message text
  final String message;

  // TR: Gönderen (user/kumo)
  // EN: Sender (user/kumo)
  final String sender;

  // TR: Zaman damgası
  // EN: Timestamp
  final DateTime timestamp;

  // TR: İlgili soru (varsa)
  // EN: Related question (if any)
  final KumoQuestion? relatedQuestion;

  // TR: Eşleşme skoru
  // EN: Match score
  final double? matchScore;

  // TR: Mesaj türü
  // EN: Message type
  final String messageType;

  // TR: Constructor
  // EN: Constructor
  KumoChatMessage({
    required this.id,
    required this.message,
    required this.sender,
    required this.timestamp,
    this.relatedQuestion,
    this.matchScore,
    this.messageType = 'text',
  });

  // TR: Kullanıcı mesajı oluştur
  // EN: Create user message
  factory KumoChatMessage.user({
    required String id,
    required String message,
    DateTime? timestamp,
  }) {
    return KumoChatMessage(
      id: id,
      message: message,
      sender: 'user',
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  // TR: Kumo mesajı oluştur
  // EN: Create kumo message
  factory KumoChatMessage.kumo({
    required String id,
    required String message,
    DateTime? timestamp,
    KumoQuestion? relatedQuestion,
    double? matchScore,
  }) {
    return KumoChatMessage(
      id: id,
      message: message,
      sender: 'kumo',
      timestamp: timestamp ?? DateTime.now(),
      relatedQuestion: relatedQuestion,
      matchScore: matchScore,
      messageType: matchScore != null ? 'matched' : 'general',
    );
  }

  // TR: JSON'dan oluşturma
  // EN: Create from JSON
  factory KumoChatMessage.fromJson(Map<String, dynamic> json) {
    return KumoChatMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      sender: json['sender'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      relatedQuestion: json['relatedQuestion'] != null
          ? KumoQuestion.fromJson(
              json['relatedQuestion'] as Map<String, dynamic>)
          : null,
      matchScore: json['matchScore'] as double?,
      messageType: json['messageType'] as String,
    );
  }

  // TR: JSON'a dönüştürme
  // EN: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'relatedQuestion': relatedQuestion?.toJson(),
      'matchScore': matchScore,
      'messageType': messageType,
    };
  }

  // TR: String gösterimi
  // EN: String representation
  @override
  String toString() {
    return 'KumoChatMessage(id: $id, sender: $sender, message: $message)';
  }
}

/// TR: KUBBE V4 Kumo Chat Logic Sınıfı
/// EN: KUBBE V4 Kumo Chat Logic Class
/// TR: V1'deki asistan mantığını modern Flutter ile birleştirir
/// EN: Combines V1's assistant logic with modern Flutter
/// TR: Anahtar kelime eşleştirme ve pırlanta cevaplar
/// EN: Keyword matching and diamond-like answers
/// TR: Akıllı cevap üretme ve kişiselleştirme
/// EN: Intelligent answer generation and personalization
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class KumoChatLogic {
  // TR: Repository
  // EN: Repository
  final KumoRepository _repository;

  // TR: Mesaj geçmişi
  // EN: Message history
  final List<KumoChatMessage> _messageHistory = [];

  // TR: Anahtar kelime ağırlıkları
  // EN: Keyword weights
  final Map<String, double> _keywordWeights = {
    'namaz': 1.0, // TR: Namaz // EN: Prayer
    'oruç': 1.0, // TR: Oruç // EN: Fasting
    'zekat': 1.0, // TR: Zekat // EN: Zakat
    'hac': 1.0, // TR: Hac // EN: Hajj
    'kuran': 1.0, // TR: Kuran // EN: Quran
    'allah': 0.8, // TR: Allah // EN: Allah
    'peygamber': 0.8, // TR: Peygamber // EN: Prophet
    'ahlak': 0.9, // TR: Ahlak // EN: Morality
    'iman': 0.9, // TR: İman // EN: Faith
    'günah': 0.8, // TR: Günah // EN: Sin
    'sevap': 0.8, // TR: Sevap // EN: Reward
    'cennet': 0.7, // TR: Cennet // EN: Heaven
    'cehennem': 0.7, // TR: Cehennem // EN: Hell
    'dualar': 0.9, // TR: Dualar // EN: Prayers
    'ibadet': 1.0, // TR: İbadet // EN: Worship
    'sünnet': 0.8, // TR: Sünnet // EN: Sunnah
    'farz': 0.9, // TR: Farz // EN: Obligatory
    'vacip': 0.9, // TR: Vacip // EN: Obligatory
    'haram': 0.8, // TR: Haram // EN: Forbidden
    'helal': 0.8, // TR: Helal // EN: Halal
    'şükür': 0.7, // TR: Şükür // EN: Gratitude
    'sabır': 0.7, // TR: Sabır // EN: Patience
    'takva': 0.8, // TR: Takva // EN: Piety
  };

  // TR: Constructor
  // EN: Constructor
  KumoChatLogic(this._repository) {
    _repository.initialize();
  }

  // TR: Mesaj işle
  // EN: Process message
  KumoChatMessage processMessage(String userMessage) {
    // TR: Kullanıcı mesajı oluştur
    // EN: Create user message
    final userChatMessage = KumoChatMessage.user(
      id: _generateMessageId(),
      message: userMessage,
    );

    // TR: Mesaj geçmişine ekle
    // EN: Add to message history
    _messageHistory.add(userChatMessage);

    // TR: En iyi eşleşmeyi bul
    // EN: Find best match
    final bestMatch = _findBestMatch(userMessage);

    // TR: Kumo cevabı oluştur
    // EN: Create kumo response
    final kumoResponse = _generateKumoResponse(userMessage, bestMatch);

    // TR: Mesaj geçmişine ekle
    // EN: Add to message history
    _messageHistory.add(kumoResponse);

    return kumoResponse;
  }

  // TR: En iyi eşleşmeyi bul
  // EN: Find best match
  KumoQuestion? _findBestMatch(String userMessage) {
    final allQuestions = _repository.getAllQuestions();

    if (allQuestions.isEmpty) return null;

    KumoQuestion? bestMatch;
    double bestScore = 0.0;

    for (final question in allQuestions) {
      final score = _calculateMatchScore(userMessage, question);

      if (score > bestScore) {
        bestScore = score;
        bestMatch = question;
      }
    }

    // TR: Minimum eşleşme skoru kontrolü
    // EN: Minimum match score check
    return bestScore >= 0.3 ? bestMatch : null;
  }

  // TR: Eşleşme skorunu hesapla
  // EN: Calculate match score
  double _calculateMatchScore(String userMessage, KumoQuestion question) {
    double score = 0.0;
    final userWords = _extractKeywords(userMessage.toLowerCase());

    // TR: Soru metni ile eşleşme
    // EN: Match with question text
    score += _textSimilarity(
            userMessage.toLowerCase(), question.question.toLowerCase()) *
        0.4;

    // TR: Anahtar kelime eşleşmesi
    // EN: Keyword matching
    for (final keyword in question.keywords) {
      for (final userWord in userWords) {
        if (userWord.contains(keyword.toLowerCase()) ||
            keyword.toLowerCase().contains(userWord)) {
          score += _keywordWeights[keyword.toLowerCase()] ?? 0.5;
        }
      }
    }

    // TR: Kategori ağırlığı
    // EN: Category weight
    if (userMessage.toLowerCase().contains(question.category.toLowerCase())) {
      score += 0.2;
    }

    // TR: Normalize et
    // EN: Normalize
    return score.clamp(0.0, 1.0);
  }

  // TR: Anahtar kelimeleri çıkar
  // EN: Extract keywords
  List<String> _extractKeywords(String text) {
    // TR: Basit kelime ayırma (V1 mantığı)
    // EN: Simple word splitting (V1 logic)
    final words = text.split(RegExp(r'[\s.,!?;:]+'));
    return words.where((word) => word.isNotEmpty).toList();
  }

  // TR: Metin benzerliği hesapla
  // EN: Calculate text similarity
  double _textSimilarity(String text1, String text2) {
    // TR: Basit benzerlik hesaplaması (V1 mantığı)
    // EN: Simple similarity calculation (V1 logic)
    final words1 = _extractKeywords(text1);
    final words2 = _extractKeywords(text2);

    int commonWords = 0;
    for (final word1 in words1) {
      for (final word2 in words2) {
        if (word1 == word2) {
          commonWords++;
          break;
        }
      }
    }

    return commonWords / (words1.length + words2.length - commonWords);
  }

  // TR: Kumo cevabı oluştur
  // EN: Generate kumo response
  KumoChatMessage _generateKumoResponse(
      String userMessage, KumoQuestion? bestMatch) {
    final responseId = _generateMessageId();

    if (bestMatch != null) {
      // TR: Eşleşme varsa - pırlanta cevap
      // EN: If match exists - diamond answer
      final matchScore = _calculateMatchScore(userMessage, bestMatch);

      // TR: Kişiselleştirilmiş cevap
      // EN: Personalized response
      final personalizedAnswer =
          _personalizeAnswer(bestMatch.answer, userMessage);

      return KumoChatMessage.kumo(
        id: responseId,
        message: personalizedAnswer,
        relatedQuestion: bestMatch,
        matchScore: matchScore,
      );
    } else {
      // TR: Eşleşme yoksa - genel cevap
      // EN: If no match - general response
      final generalResponse = _generateGeneralResponse(userMessage);

      return KumoChatMessage.kumo(
        id: responseId,
        message: generalResponse,
      );
    }
  }

  // TR: Cevabı kişiselleştir
  // EN: Personalize answer
  String _personalizeAnswer(String originalAnswer, String userMessage) {
    // TR: Basit kişiselleştirme (V1 mantığı)
    // EN: Simple personalization (V1 logic)

    // TR: Selamlama ekle
    // EN: Add greeting
    if (userMessage.toLowerCase().contains('merhaba') ||
        userMessage.toLowerCase().contains('selam')) {
      return 'Merhaba! $originalAnswer';
    }

    // TR: Teşekkür ekle
    // EN: Add thanks
    if (userMessage.toLowerCase().contains('teşekkür') ||
        userMessage.toLowerCase().contains('sağ ol')) {
      return 'Rica ederim. $originalAnswer';
    }

    return originalAnswer;
  }

  // TR: Genel cevap oluştur
  // EN: Generate general response
  String _generateGeneralResponse(String userMessage) {
    // TR: V1'deki genel cevaplar
    // EN: General responses from V1

    final generalResponses = [
      'Bu konuda daha fazla bilgi için lütfen daha spesifik bir soru sorun.',
      'İslam\'ın temel prensipleri hakkında bilgi almak ister misiniz?',
      'Sorunuzun cevabını bulamadım. Lütfen başka bir şekilde ifade edin.',
      'Bu konuda size yardımcı olabilirim. Lütfen spesifik bir soru sorun.',
      'İslam ahlakı, ibadet veya güncel konular hakkında sorularınızı bekliyorum.',
    ];

    // TR: Rastgele cevap seç
    // EN: Select random response
    generalResponses.shuffle();
    return generalResponses.first;
  }

  // TR: Mesaj ID'si oluştur
  // EN: Generate message ID
  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}';
  }

  // TR: Mesaj geçmişini al
  // EN: Get message history
  List<KumoChatMessage> getMessageHistory() {
    return List.from(_messageHistory);
  }

  // TR: Mesaj geçmişini temizle
  // EN: Clear message history
  void clearMessageHistory() {
    _messageHistory.clear();
  }

  // TR: Önerilen soruları al
  // EN: Get suggested questions
  List<KumoQuestion> getSuggestedQuestions({int limit = 5}) {
    // TR: Popüler kategorilerden seç
    // EN: Select from popular categories
    final popularCategories = ['Ahlak', 'İbadet', 'Güncel'];
    final suggestedQuestions = <KumoQuestion>[];

    for (final category in popularCategories) {
      final categoryQuestions = _repository.getQuestionsByCategory(category);
      suggestedQuestions.addAll(categoryQuestions.take(2));
    }

    // TR: Karıştır ve limit kadar döndür
    // EN: Shuffle and return limited number
    suggestedQuestions.shuffle();
    return suggestedQuestions.take(limit).toList();
  }

  // TR: İlgili soruları al
  // EN: Get related questions
  List<KumoQuestion> getRelatedQuestions(String lastUserMessage,
      {int limit = 3}) {
    final bestMatch = _findBestMatch(lastUserMessage);

    if (bestMatch != null) {
      return _repository.getRelatedQuestions(bestMatch.id, limit: limit);
    }

    // TR: Eşleşme yoksa rastgele sorular döndür
    // EN: If no match, return random questions
    return _repository.getAllQuestions().take(limit).toList();
  }

  // TR: İstatistikleri al
  // EN: Get statistics
  Map<String, dynamic> getStatistics() {
    final totalMessages = _messageHistory.length;
    final userMessages =
        _messageHistory.where((m) => m.sender == 'user').length;
    final kumoMessages =
        _messageHistory.where((m) => m.sender == 'kumo').length;
    final matchedMessages =
        _messageHistory.where((m) => m.messageType == 'matched').length;

    return {
      'totalMessages': totalMessages,
      'userMessages': userMessages,
      'kumoMessages': kumoMessages,
      'matchedMessages': matchedMessages,
      'matchRate': userMessages > 0 ? matchedMessages / userMessages : 0.0,
      'repositoryStats': _repository.getStatistics(),
    };
  }

  // TR: Anahtar kelime ağırlıklarını güncelle
  // EN: Update keyword weights
  void updateKeywordWeights(Map<String, double> newWeights) {
    _keywordWeights.addAll(newWeights);
  }

  // TR: Anahtar kelime ağırlıklarını al
  // EN: Get keyword weights
  Map<String, double> getKeywordWeights() {
    return Map.from(_keywordWeights);
  }
}

/// TR: Kumo Chat Logic Provider - V4 yeniliği
/// EN: Kumo Chat Logic Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final kumoChatLogicProvider = Provider<KumoChatLogic>((ref) {
  final repository = ref.read(kumoRepositoryProvider);
  return KumoChatLogic(repository);
});
