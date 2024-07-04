import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/pages/set_new_password_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;

  const VerifyCodePage({super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetCodeVerifiedFailed) {
          _isLoading = false;
          showSnackBar(context, state.message);
        }
        if (state is PasswordResetCodeVerifiedSuccess) {
          _isLoading = false;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SetNewPasswordPage(code: _codeController.text),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.verifyCode_chkEmail,
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
                  '${AppLocalizations.of(context)!.verifyCode_sentLink} ${widget.email}\n${AppLocalizations.of(context)!.verifyCode_enterCode}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              PinCodeTextField(
                appContext: context,
                length: 5,
                controller: _codeController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8.0),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 32.0),
              LargeGradientButton(
                onPressed: () {
                  if (_codeController.text.length == 5) {
                    context
                        .read<AuthBloc>()
                        .add(PasswordResetCodeVerified(_codeController.text));
                  }
                },
                isDisabled: _codeController.text.length != 5,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(AppLocalizations.of(context)!.verifyCode_verifyCode,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 16.0),
              // TextButton(
              //   onPressed: () {
              //     // Add logic to resend email
              //   },
              //   child: const Text(
              //     'Haven\'t got the email yet? Resend email',
              //     style: TextStyle(
              //       fontSize: 14.0,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
