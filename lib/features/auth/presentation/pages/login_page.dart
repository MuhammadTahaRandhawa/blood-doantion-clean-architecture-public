import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/pages/bottom_navigation_bar.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/helpers/login_form_validator.dart';
import 'package:myapp/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:myapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:myapp/features/auth/presentation/widgets/app_bar.dart';
import 'package:myapp/features/auth/presentation/widgets/auth_button.dart';
import 'package:myapp/features/basic_information/presentation/pages/user_basic_information.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserFetchedFailure) {
              showSnackBar(context, state.message);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BasicInformationPage(),
              ));
            }
            if (state is UserFetchedLoading) {}
            if (state is UserFetchedSuccess) {
              _isLoading = false;
              showSnackBar(context,
                  '${AppLocalizations.of(context)!.loginPage_signAs} ${_emailController.text}');
              context.read<UserCubit>().initializeUser(state.user);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AppBottomNavigation(),
                  ),
                  (route) => false);
            }
          },
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                _isLoading = false;
                showSnackBar(context, state.message);
              }
              if (state is AuthLoading) {
                _isLoading = true;
              }
              if (state is AuthSuccess) {
                context.read<UserBloc>().add(UserDataFetchedRemotly());
              }
              if (state is! AuthLoading) {
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
                              icon: const Icon(Icons.email),
                              hintText:
                                  AppLocalizations.of(context)!.loginPage_email,
                              obsecureText: false,
                              validator: LogInFormValidator.emailValidator,
                              controller: _emailController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              icon: const Icon(Icons.lock),
                              hintText:
                                  AppLocalizations.of(context)!.loginPage_pass,
                              obsecureText: true,
                              validator: LogInFormValidator.passwordValidator,
                              controller: _passWordController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordPage(),
                                          ));
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loginPage_forgetPass,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                        //.copyWith(color: Theme.of(context).primaryColor),
                                        )),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            AuthButton(
                                isLoading: _isLoading,
                                onPressed: _onPressedLogin,
                                child: Text(AppLocalizations.of(context)!
                                    .loginPage_logInBtn)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ));
                        },
                        child: RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .loginPage_alreadyAccount,
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
                                      " ${AppLocalizations.of(context)!.signupPage_signupBtn}",
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
          )),
    );
  }

  void _onPressedLogin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(OnLoginWithEmailPassword(
          email: _emailController.text, password: _passWordController.text));
    }
  }
}
