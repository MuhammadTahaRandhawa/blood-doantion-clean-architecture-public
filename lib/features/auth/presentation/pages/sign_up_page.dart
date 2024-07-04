import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/helpers/signup_form_validators.dart';
import 'package:myapp/features/auth/presentation/pages/login_page.dart';
import 'package:myapp/features/auth/presentation/widgets/app_bar.dart';
import 'package:myapp/features/auth/presentation/widgets/auth_button.dart';
import 'package:myapp/features/basic_information/presentation/pages/user_basic_information.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.35),
          child: const AuthAppBar()),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
            _isLoading = false;
          }
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          }
          if (state is AuthSuccess) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const BasicInformationPage(),
            ));
            _isLoading = false;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                          hintText:
                              AppLocalizations.of(context)!.signupPage_email,
                          icon: const Icon(Icons.email),
                          obsecureText: false,
                          validator: SignUpFormValidator.emailValidator,
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                          icon: const Icon(Icons.lock),
                          hintText:
                              AppLocalizations.of(context)!.signupPage_pass,
                          obsecureText: true,
                          validator: SignUpFormValidator.passwordValidator,
                          controller: _passWordController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AuthButton(
                            isLoading: _isLoading,
                            onPressed: onPressedSignUp,
                            child: Text(AppLocalizations.of(context)!
                                .signupPage_signupBtn)),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!
                                .signupPage_alreadyAccount,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                            children: [
                          TextSpan(
                              text:
                                  " ${AppLocalizations.of(context)!.loginPage_logInBtn}",
                              style: const TextStyle().copyWith(
                                  color: AppPallete.primaryColor,
                                  fontWeight: FontWeight.bold))
                        ]))),
                // Text(
                //   AppLocalizations.of(context)!.loginPage_or,
                //   style: Theme.of(context).textTheme.bodyMedium,
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SocialLoginButton(
                //       icon: const Icon(Icons.facebook),
                //       color: Colors.blue,
                //       onPressed: () {},
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     SocialLoginButton(
                //       icon: const ImageIcon(AssetImage(
                //         kIsWeb
                //             ? 'images/google_icon.png'
                //             : 'assets/images/google_icon.png',
                //       )),
                //       color: Colors.red,
                //       onPressed: () {
                //         context
                //             .read<AuthBloc>()
                //             .add(OnAuthenticatedWithGoogle());
                //       },
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onPressedSignUp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(OnSignUpwithEmailPassword(
          email: _emailController.text, password: _passWordController.text));
    }
  }
}
