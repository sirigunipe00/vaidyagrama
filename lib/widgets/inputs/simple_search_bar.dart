import 'dart:async';
import 'package:flutter/material.dart';

class SimpleSearchBar extends StatefulWidget {
  const SimpleSearchBar({
    required this.hintText,
    required this.onSearch,
    required this.onCancel,
    this.initial,
    super.key,
  });

  final String hintText;
  final String? initial;
  final Function(String) onSearch;
  final Function() onCancel;

  @override
  State<SimpleSearchBar> createState() => _SimpleSearchBarState();
}

class _SimpleSearchBarState extends State<SimpleSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
         widget.onSearch(query);
      });
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFdadbdc).withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search, color: Colors.black54),
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onSearch,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Urbanist',
              ),

              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 17,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                isDense: true,
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          key: const Key('clear-search'),
                          icon: const Icon(Icons.clear, color: Colors.black38),
                          onPressed: _clearField,
                        )
                        : null,
              ),
              textInputAction: TextInputAction.search,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _clearField() {
    if (_controller.text.isNotEmpty) {
      widget.onCancel();
      widget.onSearch('');
      _controller.clear();
      _focusNode.unfocus();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.clear();
  }
}
