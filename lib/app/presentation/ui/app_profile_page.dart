


import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/core/core.dart';

import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';

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
