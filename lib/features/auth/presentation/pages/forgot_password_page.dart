import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserInformationValidator userInformationValidator =
      UserInformationValidator();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSentFailure) {
          log('PasswordResetEmailSentFailure');
          _isLoading = false;
          showSnackBar(context, state.message);
        }
        if (state is PasswordResetEmailSentSuccess) {
          log('PasswordResetEmailSentSuccess');
          _isLoading = false;

          log('complete');
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.forgetPassPage_forgetPass,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.forgetPassPage_emailForReset,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: AppLocalizations.of(context)!
                          .forgetPassPage_yourEmail,
                      validator: userInformationValidator.emailValidator,
                      keyBoardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    LargeGradientButton(
                      isDisabled: _isLoading,
                      onPressed: _onPressedResetButton,
                      child: Text(
                        AppLocalizations.of(context)!.forgetPassPage_resetPass,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressedResetButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    context.read<AuthBloc>().add(PasswordResetEmailSent(_emailController.text));
  }
}
