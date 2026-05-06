

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:vaidyagrama/core/core.dart';
// import 'dart:math' as math;

// import 'package:vaidyagrama/features/auth/presentation/bloc/auth/auth_cubit.dart';
// import 'package:vaidyagrama/styles/app_color.dart';
// import 'package:vaidyagrama/widgets/buttons/app_btn.dart';

// class AppProfilePage extends StatelessWidget {
//   const AppProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final size = MediaQuery.of(context).size;
//     // final height = size.height;
//     // final width = size.width;
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final height = constraints.maxHeight;
//           final width = constraints.maxWidth;
//           return Column(
//             children: [
//               Container(
//                 height: height * 0.28,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFFDCB27),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * 0.04,
//                           vertical: height * 0.015,
//                         ),
//                         child: const Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               'Profile',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: height * 0.01),
//                       SvgPicture.asset(
//                         'assets/images/hormann_logo.svg',
//                         height: height * 0.05,
//                       ),
//                       SizedBox(height: height * 0.02),
//                     ],
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: Column(
//                   children: [
//                     Transform.translate(
//                       offset: Offset(0, -height * 0.06),
//                       child: Container(
//                         width: width * 0.85,
//                         padding: EdgeInsets.all(width * 0.05),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(24),
//                           border: const Border(
//                             bottom: BorderSide(
//                               color: AppColors.darkBlue,
//                               width: 10,
//                             ),
//                           ),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
                
                            
//                             Stack(
//                               children: [
//                                 Container(
//                                 padding: EdgeInsets.all(width * 0.02),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(60),
//                                   // shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: AppColors.darkBlue,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: width * 0.09,
//                                   backgroundColor: Colors.transparent,
//                                   child: Icon(
//                                     Icons.person,
//                                     size: width * 0.12,
//                                     color: const Color(0xFFFDCB27),
//                                   ),
//                                 ),
//                               ),
                
//                               Positioned.fill(
//                               child: CustomPaint(
//                                   painter: _RightArcPainter(),
//                                 ),
//                             ),
                
//                               ],
//                             ),
                            
                
                            
//                             // 🟡 Right-Side Yellow Arc
                             
//                             SizedBox(height: height * 0.015),
//                             Text(
//                               context.user.firstName ?? '',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: width * 0.045,
//                                 color: Colors.black,
//                                 fontFamily: 'Urbanist',
//                               ),
//                             ),
//                             SizedBox(height: height * 0.02),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: width * 0.04,
//                                 vertical: height * 0.008,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.darkBlue,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 context.user.email.toString(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: width * 0.035,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                
//                     _infoRow(
//                       'Company',
//                       const Text(
//                         'Shakti Hormann Private Limited',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontFamily: 'Urbanist',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
                
//                     _infoRow(
//                       'App Version',
//                       FutureBuilder<String>(
//                         future: _appversion(),
//                         builder: (_, snapshot) {
//                           if (snapshot.connectionState ==
//                                   ConnectionState.done &&
//                               snapshot.hasData) {
//                             return Text(
//                               snapshot.data!,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                                 fontFamily: 'Urbanist',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             );
//                           }
//                           return const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           );
//                         },
//                       ),
//                     ),
                
//                     SizedBox(height: height * 0.035),
                
//                     Center(
//                       child: AppButton(
//                         label: 'Logout',
//                         width: width * 0.85,
//                         icon: Transform.rotate(
//                           angle: 180 * math.pi / 180,
//                           child: const Icon(
//                             Icons.logout_outlined,
//                             color: AppColors.white,
//                           ),
//                         ),
//                         onPressed: context.cubit<AuthCubit>().signOut,
//                         bgColor: AppColors.darkBlue,
//                         margin: EdgeInsets.symmetric(
//                           horizontal: width * 0.08,
//                         ),
//                       ),
//                     ),
                
//                     SizedBox(height: height * 0.08),
                
//                     Column(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/logo/EasyCloud Logo 150 x 80.svg',
//                           height: height * 0.05,
//                           fit: BoxFit.contain,
//                         ),
//                         SizedBox(height: height * 0.005),
//                         const Text(
//                           'Powered by EasyCloud',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                             fontFamily: 'Urbanist',
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   static Widget _infoRow(String label, Widget value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//               fontFamily: 'Urbanist',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           value,
//         ],
//       ),
//     );
//   }
// }

// Future<String> _appversion() async {
//   final pinfo = await PackageInfo.fromPlatform();
//   final version = pinfo.version;
//   final buildNumber = pinfo.buildNumber;
//   return '$version ($buildNumber)';
// }

// class _RightArcPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFFDCB27)
//       ..strokeWidth = 6.5
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     // Make the arc rectangle slightly *larger*
//     final double extra = 6; // increase this value to make arc larger
//     final rect = Rect.fromLTWH(
//       -extra, // shift left
//       -extra, // shift up
//       size.width + extra * 2, // expand width
//       size.height + extra * 2, // expand height
//     );

//     canvas.drawArc(
//       rect.deflate(2),
//       math.pi * 1.5, // start from top
//       math.pi / 0.9, // sweep angle
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }


import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vaidyagrama/core/core.dart';

import 'package:vaidyagrama/features/auth/presentation/bloc/auth/auth_cubit.dart';

class AppProfilePage extends StatefulWidget {
  const AppProfilePage({super.key});

  @override
  State<AppProfilePage> createState() => _AppProfilePageState();
}

class _AppProfilePageState extends State<AppProfilePage> {
  Future<String> _appVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  String _getUserName() {
    try {
      final user = context.user;
      if (user.fullName?.isNotEmpty == true) {
        return user.fullName!;
      } else if (user.name.isNotEmpty) {
        return user.name;
      } else if (user.firstName?.isNotEmpty == true) {
        return user.firstName!;
      }
      return 'User';
    } catch (_) {
      return 'User';
    }
  }

  String _getUserEmail() {
    try {
      final user = context.user;
      return user.email?.isNotEmpty == true ? user.email! : 'N/A';
    } catch (_) {
      return 'N/A';
    }
  }

  String _getOrganization() {
    try {
      final user = context.user;
      if (user.roleProfileName?.isNotEmpty == true) {
        return user.roleProfileName!;
      } else if (user.depoName?.isNotEmpty == true) {
        return user.depoName!;
      } else if (user.plantName?.isNotEmpty == true) {
        return user.plantName!;
      }
      return 'Scoops';
    } catch (_) {
      return 'Scoops';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFedaed), 
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              children: [
                SizedBox(height: height * 0.02),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 8),
                      // child: Container(
                      //             width: 41,
                      //             height: 41,
                      //             decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               borderRadius: BorderRadius.circular(12),
                      //               border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
                      //             ),
                      //             child: IconButton(
                      //               icon: const Icon(Icons.arrow_back_ios_new,
                      //                   color: Colors.pink, size: 20),
                      //               onPressed: () => Navigator.pop(context),
                      //               splashRadius: 24,
                      //             ),
                      //           ),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Urbanist'),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Image.asset(
                  'assets/images/scoops_logo.png',
                  height: height * 0.20,
                ),
                SizedBox(height: height * 0.02),

                // Info Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Name', _getUserName()),
                      _divider(),
                      _infoRow('Email', _getUserEmail()),
                      _divider(),
                      _infoRow('Organization', _getOrganization()),
                      _divider(),
                      FutureBuilder<String>(
                        future: _appVersion(),
                        builder: (context, snapshot) {
                          return _infoRow(
                            'App Version',
                            snapshot.hasData ? snapshot.data! : '0.0.1',
                          );
                        },
                      ),
                      _divider(),
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6464),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            context.cubit<AuthCubit>().signOut();
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Urbanist'
                            ),
                          ),
                        ),
                      ),
                    ],
                    
                  ),
                ),
                const SizedBox(height: 10,),
                  Image.asset('assets/images/easycloud_logo.png',
                    height: 50, width: 60),
                const SizedBox(height: 4),
                const Text(
                  'Powered by EasyCloud',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Urbanist'
                  ),
                ),


              ],
            ),


           
          ],
        ),
      ),


    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist'
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist'
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(thickness: 1, color: Colors.black12);
}
