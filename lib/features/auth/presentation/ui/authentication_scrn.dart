import 'package:app/widgets/app_spacer.dart';
import 'package:app/widgets/buttons/app_btn.dart';
import 'package:app/widgets/inputs/app_text_field.dart';
import 'package:app/widgets/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:app/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:app/styles/app_color.dart';
import 'package:app/widgets/dailogs/app_dialogs.dart';


class AuthenticationScrn extends StatefulWidget {
  const AuthenticationScrn({super.key});

  @override
  State<AuthenticationScrn> createState() => _AuthenticationScrnState();
}

class _AuthenticationScrnState extends State<AuthenticationScrn> {
  late final TextEditingController username;
  late final TextEditingController pswd;
  bool showPswd = true;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    pswd = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              margin: const EdgeInsets.all(12.0),
              defaultHeight: 12.0,
              children: [
                SizedBox(
                  width: context.sizeOfWidth,
                  child: Image.asset(context.appFlavor.logo, height: 200),
                ),
                Text('Login',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Please login to continue",
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacer.p12(),
                AppTextField(
                  title: 'Email',
                  inputType: TextInputType.emailAddress,
                  controller: username,
                ),
                AppTextField(
                  title: 'Password',
                  controller: pswd,
                  obscureText: showPswd,
                  suffixIcon: InkWell(
                    onTap: togglePswd,
                    child: Text(
                      showPswd ? ' show ' : ' hide ',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.transparent,
                        shadows: [
                          const Shadow(color: AppColors.white, offset: Offset(0, -5)),
                        ],
                        decorationColor: AppColors.white,
                        decoration: TextDecoration.underline,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                
                BlocConsumer<SignInCubit, SignInState>(
                  listener: (_, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: context.cubit<AuthCubit>().authCheckRequested,
                      failure: (failure) => AppDialog.showErrorDialog(
                        context, 
                        title: failure.title,
                        content: failure.error,
                        onTapDismiss: context.close,
                      ),
                    );
                  },
                  builder: (_, state) {
                    return AppButton(
                      label: 'Sign In',
                      isLoading: state.isLoading,
                      margin: const EdgeInsets.all(12),
                      onPressed: () => context
                          .cubit<SignInCubit>()
                          .login(username.text, pswd.text),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePswd() => setState(() {
        showPswd = !showPswd;
      });
}