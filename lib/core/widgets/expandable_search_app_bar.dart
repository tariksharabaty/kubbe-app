import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'voice_search_modal.dart';

class ExpandableSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String hintText;
  final Function(String) onSearchChanged;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ExpandableSearchAppBar({
    super.key,
    required this.title,
    required this.onSearchChanged,
    this.hintText = "Ara...",
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<ExpandableSearchAppBar> createState() => _ExpandableSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ExpandableSearchAppBarState extends State<ExpandableSearchAppBar> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchChanged("");
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);
    final Color textColor = widget.foregroundColor ?? Colors.black;

    return AppBar(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: _isSearching
          ? IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: textColor),
              onPressed: _toggleSearch,
            )
          : widget.leading ?? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: widget.onSearchChanged,
              style: GoogleFonts.inter(color: textColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(PhosphorIcons.microphone(), color: purple, size: 20),
                  onPressed: () => VoiceSearchModal.show(context),
                ),
              ),
              cursorColor: purple,
            )
          : Text(
              widget.title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 20,
              ),
            ),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: Icon(Icons.search_rounded, color: textColor),
            onPressed: _toggleSearch,
          ),
        if (_isSearching && _searchController.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.close_rounded, color: textColor),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged("");
            },
          ),
        if (!_isSearching && widget.actions != null) ...widget.actions!,
      ],
    );
  }
}
