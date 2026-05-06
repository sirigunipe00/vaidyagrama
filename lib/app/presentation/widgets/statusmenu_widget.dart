import 'package:flutter/material.dart';
import 'package:vaidyagrama/app/presentation/widgets/app_page_view2.dart';
import 'package:vaidyagrama/app/presentation/widgets/staticlist_tile.dart';


class StatusMenuWidget extends StatefulWidget {
  const StatusMenuWidget({
    super.key,
    required this.onChange,
    required this.items,
    this.defaultSel,
    this.defaultStatus,
    required this.mode,
  });

  final List<String> items;
  final String? defaultSel;
  final void Function(String status) onChange;
  final String? defaultStatus;
  final PageMode2 mode;
  @override
  State<StatusMenuWidget> createState() => _StatusMenuWidgetState();
}

class _StatusMenuWidgetState extends State<StatusMenuWidget>
    with StatusModeSelectionMixin {
  String? _selectedDuration;
  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.defaultSel ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () async {
            final selected = await showOptions(
              context,
              defaultValue: _selectedDuration,
              pageMode: widget.mode,
            );

            if (selected != null) {
              setState(() {
                _selectedDuration = selected;
              });
            } 


            widget.onChange.call(selected ?? _selectedDuration ?? '');
          },
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.filter_list,
              size: 20,
              color: Colors.green),
            ),
          ),
        ),
      
    );

    // return DropdownButtonFormField(
    // isDense: true,
    //   isExpanded: false,
    //   value: _selectedDuration,
    //   dropdownColor: AppColors.white,
    //   decoration: InputDecoration(
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    //     enabledBorder: OutlineInputBorder(
    //         borderSide: const BorderSide(
    //           color: AppColors.white,
    //         ),
    //         borderRadius: BorderRadius.circular(8)),
    //     fillColor: Colors.white,
    //     filled: true,
    //     border: InputBorder.none,
    //   ),
    //   items: widget.items.map((e) {
    //     return DropdownMenuItem<String>(
    //       value: e,
    //       alignment: Alignment.center,
    //       child: Text(e,
    //           style: context.textTheme.labelLarge
    //               ?.copyWith(fontWeight: FontWeight.bold)),
    //     );
    //   }).toList(),
    //   onChanged: (String? value) {
    //     setState(() {
    //       _selectedDuration = value;
    //     });
    //     widget.onChange.call(value!);
    //   },
    // );
  }
}
