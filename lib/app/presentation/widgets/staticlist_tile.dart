import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vaidyagrama/app/presentation/widgets/app_page_view2.dart';
import 'package:vaidyagrama/styles/app_color.dart';


mixin StatusModeSelectionMixin {
  Future<String?> showOptions(
    BuildContext context, {
    String? defaultValue,
    required PageMode2 pageMode,
  }) async {
    final List<String> filters;
    switch (pageMode) {
      case PageMode2.gateentry:
      case PageMode2.gateexit:
      case PageMode2.proofOfDelivery:
      
        filters = ['Draft', 'Submitted', 'All'];
        break;
      case PageMode2.logisticRequest:
        filters = [
          'Transporter Confirmed',
          'Transporter Rejected',
          'Pending From Transporter',
          'Draft',
          'All',
        ];
        break;
      case PageMode2.transportConfirmation:
        filters = [
          'Transporter Confirmed',
          'Transporter Rejected',
          'Pending From Transporter',
          'All',
        ];
        break;
        case PageMode2.vehicleReporting:
     filters =[
      'Draft',
      'Reported',
      'Rejected',
      'Cancelled',
      'All'
     ];
     break;
     case PageMode2.loadingConfirmation:
     filters =[
      'Reported',
      'Submitted',
      'All'
     ];

       
    }

    return await showModalBottomSheet<String>(
      backgroundColor: Colors.transparent,
      context: context,
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children:
                      filters
                          .map(
                            (filter) => _StatusListTile(
                              mode: filter,
                              value: defaultValue,
                              onTap: () => context.pop(filter),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
    );
  }
}

class _StatusListTile extends StatelessWidget {
  const _StatusListTile({required this.mode, required this.value, this.onTap});

  final String mode;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value == mode,
      onChanged: (_) => onTap?.call(),
      checkColor: AppColors.white,
      activeColor: AppColors.green,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: const VisualDensity(vertical: -3),
      contentPadding: EdgeInsets.zero,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: Text(
        mode,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
