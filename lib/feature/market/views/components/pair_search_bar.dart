import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';

class PairSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const PairSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<PairSearchBar> createState() => _PairSearchBarState();
}

class _PairSearchBarState extends State<PairSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    setState(() {});
    widget.onChanged(query);
  }

  void _clear() {
    setState(_controller.clear);
    widget.onClear();
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          onTapOutside: (_) {
            _dismissKeyboard();
          },
          onSubmitted: (_) {
            _dismissKeyboard();
          },
          cursorColor: context.colors.textPrimary,
          style: context.bodyLarge,
          textInputAction: TextInputAction.search,
          autocorrect: false,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            filled: true,
            fillColor: context.colors.surface,
            hintText: context.tr(LocaleKeys.market_pairs_search_hint),
            hintStyle: context.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.colors.textSecondary,
            ),
            prefixIconConstraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _clear,
                    tooltip: context.tr(LocaleKeys.market_pairs_search_clear),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 44,
                      height: 44,
                    ),
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.colors.textSecondary,
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder get _border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}
