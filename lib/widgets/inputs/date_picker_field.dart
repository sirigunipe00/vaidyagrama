import 'package:flutter/material.dart';
import 'package:vaidyagrama/core/core.dart';
import 'package:vaidyagrama/styles/app_color.dart';
import 'package:vaidyagrama/widgets/caption_text.dart';
import 'package:vaidyagrama/widgets/spaced_column.dart';
class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.onSelected,
    this.initialDate,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon = const Icon(Icons.today_rounded),
    this.isRequired = false,
    this.dateformat = 'dd-MM-yyyy',
    this.fillColor,
    this.initialValue,
  });

  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? initialDate;
  final String dateformat;
  final bool readOnly;
  final Function(DateTime date) onSelected;
  final String? hintText;
  final Widget? suffixIcon;
  final String? initialValue;
  final Color? fillColor;
  final bool isRequired;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    String dateToShow;
    if (widget.initialValue?.isNotEmpty == true) {
      dateToShow = widget.initialValue!;
    } else if (widget.initialDate?.isNotEmpty == true) {
      dateToShow = widget.initialDate!;
    } else {
      dateToShow = DFU.ddMMyyyy(DateTime.now());
    }

    controller = TextEditingController(text: dateToShow);
 if(widget.initialValue == null && widget.initialDate == ''){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parts = dateToShow.split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 2000;
        widget.onSelected(DateTime(year, month, day));
      }
    });
 }
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnlyMode = widget.readOnly;

    final backgroundColor =
        isReadOnlyMode ? AppColors.grey.withOpacity( 0.20) : Colors.white;

    final effectiveBorderColor = isReadOnlyMode
        ? Colors.grey.withOpacity( 0.3)
        : AppColors.grey.withOpacity( 0.30);

    final effectiveTextStyle = TextStyle(
      color: isReadOnlyMode
          ? AppColors.black.withOpacity( 0.7)
          : AppColors.black,
      fontSize: 14,
      fontWeight: isReadOnlyMode ? FontWeight.w500 : FontWeight.normal,
    );

    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 4.0,
      children: [
        CaptionText(title: widget.title, isRequired: widget.isRequired),
        const SizedBox(height: 3,),
        Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: effectiveBorderColor,
              width: 1, 
            ),
          ),
          child: TextField(
            style: effectiveTextStyle,
            controller: controller,
            readOnly: true, 
            onTap: () {
              if (!widget.readOnly) _showDatePicker();
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: context.textTheme.labelSmall?.copyWith(
                color: AppColors.grey,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: isReadOnlyMode
                  ? Icon(Icons.lock, size: 18, color: Colors.grey.shade500)
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
void _showDatePicker() async {
  DateTime initialDate = DateTime.now();

  if (controller.text.isNotEmpty) {
    try {
      final parts = controller.text.split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 2000;
        final parsedDate = DateTime(year, month, day);
        // initialDate = parsedDate.isBefore(DateTime.now())
        //     ? DateTime.now()
        //     : parsedDate;
             if (parsedDate.isAfter(widget.startDate) &&
            parsedDate.isBefore(widget.endDate)) {
          initialDate = parsedDate;
        }
        
      }
    } catch (_) {}
  }

  final selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: widget.startDate, 
    lastDate: widget.endDate,
  );

  if (selectedDate != null) {
    final formattedDate = DFU.ddMMyyyy(selectedDate);
    // setState(() {
      controller.text = formattedDate;
    // });
    widget.onSelected(selectedDate);
  }
}

}
