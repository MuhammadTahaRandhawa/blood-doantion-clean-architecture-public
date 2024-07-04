import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key, required this.code});

  final String code;

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserInformationValidator userInformationValidator =
      UserInformationValidator();
  final _key = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetConfirmedFailure) {
          _isLoading = false;
          showSnackBar(context, state.message);
        }
        if (state is PasswordResetConfirmedSuccess) {
          _isLoading = false;
          showSnackBar(
              context, AppLocalizations.of(context)!.newPassPage_resetComplete);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.newPassPage_setNewPass,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.newPassPage_differPrevious,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.newPassPage_password,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomTextFormField(
                  hintText:
                      AppLocalizations.of(context)!.newPassPage_enterNewPass,
                  validator: userInformationValidator.passwordValidator,
                  controller: _passwordController,
                  obsecureText: true,
                  keyBoardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.newPassPage_confirmPass,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomTextFormField(
                  hintText:
                      AppLocalizations.of(context)!.newPassPage_reEnterPass,
                  validator: userInformationValidator.passwordValidator,
                  controller: _confirmPasswordController,
                  obsecureText: true,
                ),
                const SizedBox(height: 32.0),
                LargeGradientButton(
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      return;
                    }

                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      showSnackBar(
                          context,
                          AppLocalizations.of(context)!
                              .newPassPage_passMustMatch);
                      return;
                    }

                    context.read<AuthBloc>().add(PasswordResetConfirmed(
                        widget.code, _passwordController.text));
                    setState(
                      () {
                        _isLoading = true;
                      },
                    );
                  },
                  isDisabled: _isLoading,
                  child: Text(
                    AppLocalizations.of(context)!.newPassPage_updatePass,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
