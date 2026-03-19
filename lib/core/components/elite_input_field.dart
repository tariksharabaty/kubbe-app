// TR: KUBBE V4 Elite Input Field - V4 yeniliği
// EN: KUBBE V4 Elite Input Field - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Tüm formlarda kullanılacak, 32dp radius'lu, Indigo odaklı şık giriş alanı bileşenini oluştur.
// EN: Create elegant input field component with 32dp radius and Indigo focus that can be used in all forms.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// TR: KUBBE V4 Elite Input Field Widget'ı
/// EN: KUBBE V4 Elite Input Field Widget
/// TR: Tüm formlarda kullanılacak şık giriş alanı bileşeni
/// EN: Elegant input field component that can be used in all forms
/// TR: 32dp radius ve Indigo odaklı tasarım
/// EN: 32dp radius and Indigo focused design
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
/// TR: Form validasyonu ve hata yönetimi
/// EN: Form validation and error management
class EliteInputField extends StatefulWidget {
  // TR: Label metni
  // EN: Label text
  final String label;

  // TR: Hint metni
  // EN: Hint text
  final String? hintText;

  // TR: Controller
  // EN: Controller
  final TextEditingController controller;

  // TR: Focus node
  // EN: Focus node
  final FocusNode? focusNode;

  // TR: Keyboard type
  // EN: Keyboard type
  final TextInputType keyboardType;

  // TR: Validator
  // EN: Validator
  final String? Function(String?)? validator;

  // TR: Icon
  // EN: Icon
  final IconData? icon;

  // TR: Obscure text (şifre için)
  // EN: Obscure text (for passwords)
  final bool obscureText;

  // TR: Enabled durumu
  // EN: Enabled state
  final bool enabled;

  // TR: Maksimum karakter sayısı
  // EN: Maximum character count
  final int? maxLength;

  // TR: OnChanged callback
  // EN: OnChanged callback
  final ValueChanged<String>? onChanged;

  // TR: OnSubmitted callback
  // EN: OnSubmitted callback
  final ValueChanged<String>? onSubmitted;

  // TR: Input formatter
  // EN: Input formatter
  final List<TextInputFormatter>? inputFormatters;

  // TR: Constructor
  // EN: Constructor
  const EliteInputField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.icon,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.hintText,
  });

  @override
  State<EliteInputField> createState() => _EliteInputFieldState();
}

class _EliteInputFieldState extends State<EliteInputField> {
  // TR: Focus node
  // EN: Focus node
  late FocusNode _focusNode;

  // TR: Hata mesajı
  // EN: Error message
  String? _errorMessage;

  // TR: Odak durumu
  // EN: Focus state
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // TR: Focus node'u başlat
    // EN: Initialize focus node
    _focusNode = widget.focusNode ?? FocusNode();

    // TR: Focus dinleyicileri ekle
    // EN: Add focus listeners
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // TR: Focus dinleyicisini kaldır
    // EN: Remove focus listener
    _focusNode.removeListener(_onFocusChange);

    // TR: Eğer kendi focus node'u ise temizle
    // EN: Clean up if it's our own focus node
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  // TR: Focus değişimi callback'i
  // EN: Focus change callback
  void _onFocusChange() {
    // TR: Durumu güncelle
    // EN: Update state
    setState(() {
      _isFocused = _focusNode.hasFocus;
      // TR: Odaklanınca hata mesajını temizle
      // EN: Clear error message when focused
      if (_isFocused) {
        _errorMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // TR: Ana içerik
      // EN: Main content
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Label
        // EN: Label
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _isFocused ? KubbeTheme.kubbeIndigo : Colors.grey,
          ),
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 8.0),

        // TR: Input field container
        // EN: Input field container
        Container(
          // TR: Container dekorasyonu
          // EN: Container decoration
          decoration: BoxDecoration(
            // TR: 32dp radius
            // EN: 32dp radius
            borderRadius: BorderRadius.circular(32.0),
            // TR: Kenar
            // EN: Border
            border: Border.all(
              // TR: Kenar rengi
              // EN: Border color
              color: _errorMessage != null
                  ? Colors.red
                  : _isFocused
                      ? KubbeTheme.kubbeIndigo
                      : Colors.grey.withValues(alpha: 0.3),
              // TR: Kenar kalınlığı
              // EN: Border width
              width: 2.0,
            ),
            // TR: Arka plan
            // EN: Background
            color: widget.enabled
                ? Colors.white
                : Colors.grey.withValues(alpha: 0.1),
            // TR: Gölge
            // EN: Shadow
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          // TR: Input field
          // EN: Input field
          child: TextFormField(
            // TR: Controller
            // EN: Controller
            controller: widget.controller,

            // TR: Focus node
            // EN: Focus node
            focusNode: _focusNode,

            // TR: Keyboard type
            // EN: Keyboard type
            keyboardType: widget.keyboardType,

            // TR: Validator
            // EN: Validator
            validator: (value) {
              // TR: Validator'ı çağır
              // EN: Call validator
              final result = widget.validator?.call(value);

              // TR: Hata mesajını güncelle
              // EN: Update error message
              setState(() {
                _errorMessage = result;
              });

              return result;
            },

            // TR: Obscure text
            // EN: Obscure text
            obscureText: widget.obscureText,

            // TR: Enabled
            // EN: Enabled
            enabled: widget.enabled,

            // TR: Max length
            // EN: Max length
            maxLength: widget.maxLength,

            // TR: Input formatters
            // EN: Input formatters
            inputFormatters: widget.inputFormatters,

            // TR: Style
            // EN: Style
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: widget.enabled ? Colors.black87 : Colors.grey,
            ),

            // TR: Decoration
            // EN: Decoration
            decoration: InputDecoration(
              // TR: Hint text
              // EN: Hint text
              hintText: widget.hintText,

              // TR: Hint style
              // EN: Hint style
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),

              // TR: Border yok
              // EN: No border
              border: InputBorder.none,

              // TR: Content padding
              // EN: Content padding
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),

              // TR: Prefix icon
              // EN: Prefix icon
              prefixIcon: widget.icon != null
                  ? Container(
                      // TR: Icon container
                      // EN: Icon container
                      margin: const EdgeInsets.only(left: 8.0, right: 12.0),
                      // TR: Icon içeriği
                      // EN: Icon content
                      child: Icon(
                        widget.icon,
                        color:
                            _isFocused ? KubbeTheme.kubbeIndigo : Colors.grey,
                        size: 24,
                      ),
                    )
                  : null,

              // TR: Suffix icon
              // EN: Suffix icon
              suffixIcon: widget.obscureText
                  ? Container(
                      // TR: Icon container
                      // EN: Icon container
                      margin: const EdgeInsets.only(right: 8.0),
                      // TR: Icon içeriği
                      // EN: Icon content
                      child: Icon(
                        Icons.visibility,
                        color:
                            _isFocused ? KubbeTheme.kubbeIndigo : Colors.grey,
                        size: 24,
                      ),
                    )
                  : null,
            ),

            // TR: On changed callback
            // EN: On changed callback
            onChanged: (value) {
              // TR: Hata mesajını temizle
              // EN: Clear error message
              if (_errorMessage != null) {
                setState(() {
                  _errorMessage = null;
                });
              }

              // TR: Callback'i çağır
              // EN: Call callback
              widget.onChanged?.call(value);
            },
          ),
        ),

        // TR: Hata mesajı
        // EN: Error message
        if (_errorMessage != null)
          Padding(
            // TR: Padding
            // EN: Padding
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            // TR: Hata metni
            // EN: Error text
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

/// TR: Elite Input Field Helper - V4 yeniliği
/// EN: Elite Input Field Helper - V4 innovation
/// TR: Elite Input Field için yardımcı fonksiyonlar
/// EN: Helper functions for Elite Input Field
class EliteInputFieldHelper {
  // TR: Sayısal validator
  // EN: Numeric validator
  // TR: TR: Sadece sayısal girişe izin verir
  // EN: EN: Allows only numeric input
  static String? numericValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }

    if (double.tryParse(value) == null) {
      return 'Lütfen geçerli bir sayı girin';
    }

    return null;
  }

  // TR: E-posta validator
  // EN: Email validator
  // TR: TR: Geçerli e-posta adresi kontrolü yapar
  // EN: EN: Checks for valid email address
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi boş bırakılamaz';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Lütfen geçerli bir e-posta adresi girin';
    }

    return null;
  }

  // TR: Telefon validator
  // EN: Phone validator
  // TR: TR: Türkiye telefon formatı kontrolü yapar
  // EN: EN: Checks Turkey phone format
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası boş bırakılamaz';
    }

    final phoneRegex = RegExp(r'^(\+90|0)?[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Lütfen geçerli bir telefon numarası girin';
    }

    return null;
  }

  // TR: Boş olmayan validator
  // EN: Not empty validator
  // TR: TR: Alanın boş olup olmadığını kontrol eder
  // EN: EN: Checks if field is not empty
  static String? notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    return null;
  }

  // TR: Minimum uzunluk validator
  // EN: Minimum length validator
  // TR: TR: Minimum uzunluk kontrolü yapar
  // EN: EN: Checks minimum length
  static String? minLengthValidator(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }

    if (value.length < minLength) {
      return 'Bu alan en az $minLength karakter olmalıdır';
    }

    return null;
  }

  // TR: Maksimum uzunluk validator
  // EN: Maximum length validator
  // TR: TR: Maksimum uzunluk kontrolü yapar
  // EN: EN: Checks maximum length
  static String? maxLengthValidator(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return null; // TR: Boş alan geçerli kabul edilir // EN: Empty field is accepted as valid
    }

    if (value.length > maxLength) {
      return 'Bu alan en fazla $maxLength karakter olabilir';
    }

    return null;
  }

  // TR: Sayısal input formatter
  // EN: Numeric input formatter
  // TR: TR: Sadece sayısal karakterlere izin verir
  // EN: EN: Allows only numeric characters
  static List<TextInputFormatter> numericInputFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }

  // TR: Telefon input formatter
  // EN: Phone input formatter
  // TR: TR: Telefon formatı için input formatter
  // EN: EN: Input formatter for phone format
  static List<TextInputFormatter> phoneInputFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
      LengthLimitingTextInputFormatter(11),
    ];
  }

  // TR: Para birimi formatter
  // EN: Currency formatter
  // TR: TR: Para birimi formatı için formatter
  // EN: EN: Formatter for currency format
  static List<TextInputFormatter> currencyInputFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final text = newValue.text;
          if (text.isEmpty) return newValue;

          // TR: Sadece bir nokta ve sayılara izin ver
          // EN: Allow only one dot and numbers
          if (text.split('.').length > 2) {
            return oldValue;
          }

          return newValue;
        },
      ),
    ];
  }
}
