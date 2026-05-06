import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaidyagrama/core/core.dart';
import 'package:vaidyagrama/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:vaidyagrama/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:vaidyagrama/styles/app_color.dart';
import 'package:vaidyagrama/widgets/dailogs/app_dialogs.dart';


class LoginScrnWidget extends StatefulWidget {
  const LoginScrnWidget({super.key});

  @override
  State<LoginScrnWidget> createState() => _LoginScrnWidgetState();
}

class _LoginScrnWidgetState extends State<LoginScrnWidget> {
  bool _obscureText = true;

  late final TextEditingController username;
  late final TextEditingController pswd;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    pswd = TextEditingController();
  }

  @override
  void dispose() {
    username.dispose();
    pswd.dispose();
    super.dispose();
  }

  bool get isFormFilled => username.text.isNotEmpty && pswd.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EC),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== Header Section =====
              Container(
                width: double.infinity,
                height: 360,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE4EC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 145,
                      top: 40,
                      child: Image.asset(
                        'assets/images/scoops_logo.png',
                        width: 125,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 89,
                      child: Image.asset(
                        'assets/images/strawberryIce.png',
                        width: 175,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      left: 256,
                      top: 215,
                      child: Image.asset(
                        'assets/images/IceColors.png',
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),


              // ===== Login Form =====
              Container(
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Access your account securely',
                        style: TextStyle(color: Colors.black54, fontSize: 15, fontFamily: 'Urbanist'),
                      ),
                      const SizedBox(height: 12),

                      // ===== Email =====
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: username,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Urbanist'),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/letter.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.pinkAccent,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ===== Password =====
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: pswd,
                        obscureText: _obscureText,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Urbanist'),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/passwordlock.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => _obscureText = !_obscureText),
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.pinkAccent,
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 4),

                      // // ===== Remember Me + Forgot Password =====
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Checkbox(
                      //           activeColor: Colors.pinkAccent,
                      //           value: _rememberMe,
                      //           onChanged: (val) {
                      //             setState(() => _rememberMe = val ?? false);
                      //           },
                      //         ),
                      //         const Text("Remember Me",
                      //             style: TextStyle(color: Colors.black, fontFamily: 'Urbanist')),
                      //       ],
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (_) => const ForgotPasswordPage(),
                      //           ),
                      //         );
                      //       },
                      //       child: const Text(
                      //         "Forgot Password?",
                      //         style: TextStyle(color: Colors.black, fontFamily: 'Urbanist'),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),

                      // ===== Login Button with Bloc =====
                      BlocConsumer<SignInCubit, SignInState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            orElse: () {},
                            success:
                                context.cubit<AuthCubit>().authCheckRequested,
                            failure: (failure) => AppDialog.showErrorDialog(
                              context,
                              title: failure.title,
                              content: failure.error,
                              onTapDismiss: context.close,
                            ),
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.darkBlue,
                              ),
                            ),
                            orElse: () => SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFormFilled
                                      ? Colors.pinkAccent
                                      : const Color.fromARGB(
                                          255, 187, 187, 187),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                // onPressed: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (_) =>  BlocProvider(
                                //         create: (_) =>
                                //             AppUpdateBlocprovider.get()
                                //                 .appversionCubit()
                                //               ..request(),
                                //         child: const AppHomePage(),
                                //     )
                                //   )
                                //   );
                                // },
                                onPressed: isFormFilled
                                    ? () {
                                        context.cubit<SignInCubit>().login(
                                              username.text,
                                              pswd.text,
                                            );
                                      }
                                    : null,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // ===== Footer =====
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/easycloud_logo.png',
                              width: 60,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Powered by EasyCloud',
                              style: TextStyle(
                                color: Color.fromARGB(255, 63, 63, 63),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
