import 'package:flutter/material.dart';
import 'package:vaidyagrama/widgets/caption_text.dart';

class TimeField extends StatefulWidget {
  const TimeField({
    super.key,
    required this.title,
    this.hintText,
    this.initialTime,
    required this.onTimeChanged,
    this.readOnly = false,
    this.isRequired = false,

  });

  final String title;
  final String? hintText;
  final String? initialTime;
  final ValueChanged<String> onTimeChanged;
  final bool readOnly;
   final bool isRequired;

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  late TextEditingController _controller;

 @override
void initState() {
  super.initState();

  if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
    _controller = TextEditingController(text: widget.initialTime);
  } else {
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final currentTime = '$hour:$minute';

    _controller = TextEditingController(text: currentTime);

    // notify parent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTimeChanged(currentTime);
    });
  }
}


  Future<void> _pickTime() async {
    if (widget.readOnly) return;

    TimeOfDay initialTime = TimeOfDay.now();

     if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
    // if backend sends "HH:mm:ss", trim it
    final parts = widget.initialTime!.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      _controller = TextEditingController(text: '$hour:$minute');
    } else {
      _controller = TextEditingController(text: widget.initialTime!);
    }
  } else {
    _controller = TextEditingController();
  }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedTime != null) {
      final hour = pickedTime.hour.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final time24h = '$hour:$minute';
      

      _controller.text = time24h;
      widget.onTimeChanged(time24h);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Background & border based on readonly state
    final bgColor =
        widget.readOnly ? Colors.grey.withOpacity(0.2) : Colors.white;
    final borderColor = widget.readOnly
        ? Colors.grey.withOpacity(0.3)
        : Colors.grey.withOpacity(0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
          CaptionText(title: widget.title, isRequired: widget.isRequired),
          // const SizedBox(height: 3),
        
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          readOnly: true,
          onTap: _pickTime,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Select Time',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.readOnly ? borderColor : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            suffixIcon: const Icon(Icons.access_time),
            fillColor: bgColor,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
