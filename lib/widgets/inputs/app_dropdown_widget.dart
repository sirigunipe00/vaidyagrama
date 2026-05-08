
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/styles/app_color.dart';
import 'package:app/styles/app_text_styles.dart';
import 'package:app/widgets/caption_text.dart';

class AppDropDownWidget<T> extends StatefulWidget {
  const AppDropDownWidget({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.onSelected,
    this.defaultSelection,
    this.isMandatory = false,
    this.readOnly = false,
    this.listItemBuilder,
    this.headerBuilder,
    this.futureRequest,
    required this.color,
    this.focusNode,
  });

  final String? title;
  final FocusNode? focusNode;
  final String? hint;
  final List<T> items;
  final HeaderBuilder<T>? headerBuilder;
  final Future<List<T>> Function(String)? futureRequest;
  final Widget Function(BuildContext, T, bool, void Function())?
  listItemBuilder;
  final T? defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final dynamic Function(T? item)? onSelected;
  final Color color;

  @override
  State<AppDropDownWidget<T>> createState() => _AppDropDownWidgetState<T>();
}

class _AppDropDownWidgetState<T> extends State<AppDropDownWidget<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultSelection;
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnlyMode = widget.readOnly;

    final backgroundColor =
        isReadOnlyMode ? AppColors.grey.withValues(alpha:0.20) : Colors.white;

    final borderColor =
        isReadOnlyMode
            ? Colors.grey.withValues(alpha:0.3)
            : AppColors.grey.withValues(alpha:0.6);

    return Focus(
      focusNode: widget.focusNode,
      child: AbsorbPointer(
        absorbing: widget.readOnly,
        child: Column(
          key: widget.key,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title.containsValidValue) ...[
              CaptionText(title: widget.title!, isRequired: widget.isMandatory),
            ],
            const SizedBox(height: 4),
            CustomDropdown<T>.searchRequest(
              decoration: CustomDropdownDecoration(
                closedFillColor: backgroundColor,
                expandedFillColor: backgroundColor,
                closedBorder: Border.all(color: borderColor, width: 1),
                expandedBorder: Border.all(color: borderColor, width: 1),
                closedBorderRadius: BorderRadius.circular(8.0),
                expandedBorderRadius: BorderRadius.circular(8.0),
                hintStyle: AppTextStyles.titleLarge(
                  context,
                ).copyWith(color: AppColors.grey, fontSize: 14),
              ),
              closedHeaderPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              expandedHeaderPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              listItemPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              futureRequest: widget.futureRequest,
              hintText: widget.hint,
              items: widget.items,
              headerBuilder: widget.headerBuilder,
              listItemBuilder: widget.listItemBuilder,
              onChanged: widget.onSelected,
              initialItem: _selectedValue,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
