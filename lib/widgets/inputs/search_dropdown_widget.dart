import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:app/styles/app_color.dart';
import 'package:app/widgets/app_spacer.dart';
import 'package:app/widgets/caption_text.dart';


class SearchDropDownList<T> extends StatefulWidget {
  const SearchDropDownList({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.onSelected,
    this.defaultSelection,
    this.isMandatory = false,
    this.readOnly = false,
    this.isloading = false,
    this.listItemBuilder,
    this.headerBuilder,
    this.futureRequest,
    this.fontSize,
    this.hintBuilder,
    this.isRequired = false,
    this.closedFillColor,
    this.focusNode,
    required this.color,
  });

  final String? title;
  final String? hint;
  final double? fontSize;
  final bool isRequired;
  final List<T> items;
  final HeaderBuilder<T>? headerBuilder;
  final ListItemBuilder<T>? listItemBuilder;
  final HintBuilder? hintBuilder;
  final Future<List<T>> Function(String)? futureRequest;
  final T? defaultSelection;
  final bool isMandatory;
  final bool readOnly;
  final bool isloading;
  final Color color;
  final Color? closedFillColor;
  final void Function(T item) onSelected;
  final FocusNode? focusNode;

  @override
  State<SearchDropDownList<T>> createState() => _SearchDropDownListState<T>();
}

class _SearchDropDownListState<T> extends State<SearchDropDownList<T>>
    with WidgetsBindingObserver {
  T? _selectedValue;
  final scrollCtlr = ScrollController();
  bool _isOverlayOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultSelection;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant SearchDropDownList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultSelection != oldWidget.defaultSelection) {
      _selectedValue = widget.defaultSelection;
    }
  }

  @override
  void didChangeMetrics() {
    if (!_isOverlayOpen) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isOverlayOpen) return;
      _scrollFieldAboveKeyboard();
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollCtlr.dispose();
    super.dispose();
  }

  double _minVisibleTop(BuildContext context) {
    final view = MediaQuery.of(context);
    final appBarHeight = Scaffold.maybeOf(context)?.appBarMaxHeight ?? 0;
    return view.padding.top + appBarHeight;
  }

  /// Extra extent so a last-in-form field can move to the top of the viewport.
  /// Uses full screen height so the extent does not collapse when the keyboard opens.
  double _reservedScrollSpace(BuildContext context) {
    final view = MediaQuery.of(context);
    return (view.size.height - view.padding.top) * 0.55;
  }

  /// Height of the overlay that still fits between the field and the keyboard.
  /// Always applied so the package does not flip the overlay above the field.
  double _overlayHeightFor(BuildContext context) {
    final view = MediaQuery.of(context);
    final keyboardTop = view.size.height - view.viewInsets.bottom;
    final box = context.findRenderObject() as RenderBox?;
    final fieldTop = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero).dy
        : _minVisibleTop(context);

    // Never request more height than fits below the field, otherwise the
    // package flips the overlay above it and the list goes off-screen.
    final available = keyboardTop - fieldTop - 16;
    if (available <= 0) return 48;
    return available.clamp(48.0, 270.0);
  }

  void _scrollFieldAboveKeyboard() {
    if (!mounted || !_isOverlayOpen) return;
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final targetTop = _minVisibleTop(context) + 8;
    final fieldTop = box.localToGlobal(Offset.zero).dy;
    final delta = fieldTop - targetTop;
    if (delta.abs() < 1) return;

    final position = scrollable.position;
    if (!position.hasPixels || !position.hasContentDimensions) return;

    final next = (position.pixels + delta).clamp(
      0.0,
      position.maxScrollExtent,
    );
    if ((next - position.pixels).abs() < 1) return;
    position.jumpTo(next);
  }

  void _scheduleScrollAboveKeyboard() {
    void attempt() {
      if (!mounted || !_isOverlayOpen) return;
      _scrollFieldAboveKeyboard();
      setState(() {});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => attempt());
    Future<void>.delayed(const Duration(milliseconds: 50), attempt);
    Future<void>.delayed(const Duration(milliseconds: 180), attempt);
    Future<void>.delayed(const Duration(milliseconds: 320), attempt);
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnlyMode = widget.readOnly;

    final backgroundColor =
        isReadOnlyMode ? AppColors.grey.withValues(alpha :0.20) : Colors.white;

    final borderColor =
        isReadOnlyMode ? Colors.grey.withValues(alpha :0.3) : AppColors.grey.withValues(alpha :0.30);

    return Focus(
      focusNode: widget.focusNode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title?.isNotEmpty == true) ...[
            CaptionText(
              title: widget.title ?? '',
              color: widget.color,
              isRequired: widget.isRequired,
            ),
            AppSpacer.p4(),
          ],

          AbsorbPointer(
            absorbing: widget.readOnly || widget.isloading,
            child: CustomDropdown<T>.searchRequest(
              hideSelectedFieldWhenExpanded: true,
              excludeSelected: false,
              overlayHeight: _overlayHeightFor(context),

              closedHeaderPadding: const EdgeInsets.all(16.0),
              expandedHeaderPadding: const EdgeInsets.all(16.0),

              decoration: CustomDropdownDecoration(
                closedFillColor: backgroundColor,
                expandedFillColor: backgroundColor,
                closedBorderRadius: BorderRadius.circular(8.0),
                expandedBorderRadius: BorderRadius.circular(8.0),
                closedBorder: Border.all(
                  color: borderColor,
                  width: 1,
                ),
                expandedBorder: Border.all(
                  color: borderColor,
                  width: 1,
                ),
                hintStyle: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Urbanist',
                ),
              ),

              listItemPadding: const EdgeInsets.all(4.0),

              hintBuilder: widget.hintBuilder,
              futureRequest: widget.futureRequest,
              hintText: widget.hint,
              items: widget.items,
              headerBuilder: widget.headerBuilder,
              listItemBuilder: widget.listItemBuilder,

              visibility: (isOpen) {
                if (isOpen == _isOverlayOpen) {
                  if (isOpen) _scheduleScrollAboveKeyboard();
                  return;
                }
                setState(() => _isOverlayOpen = isOpen);
                if (isOpen) {
                  _scheduleScrollAboveKeyboard();
                }
              },

              onChanged: (value) {
                if (value != null) {
                  widget.onSelected(value);
                }
              },

              initialItem: _selectedValue,
            ),
          ),

          AppSpacer.p4(),
          if (_isOverlayOpen) SizedBox(height: _reservedScrollSpace(context)),
        ],
      ),
    );
  }
}
