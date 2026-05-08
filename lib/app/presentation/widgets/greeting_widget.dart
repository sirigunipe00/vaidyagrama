import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = context.dayOfTimeGreeting();
    final userName = context.user.firstName;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                greeting,
                style: const TextStyle(fontSize: 20, color: Colors.black87,fontFamily: 'Urbanist'),
              ),
              Text(
                userName ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Urbanist'
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}



