import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({
    super.key,
  });

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _shareCertificate() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await screenshotController.captureAndSave(
        directory.path,
        fileName: 'certificate.png',
      );

      if (imagePath != null) {
        Share.shareXFiles([XFile(imagePath)],
            text: AppLocalizations.of(context)!.certificatePage_certificate);
      }
    } catch (error) {
      print('Error capturing and sharing screenshot: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.certificatePage_appBar),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.certificatePage_gotCertificate),
            const SizedBox(
              height: 20,
            ),
            Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all()),
                      padding: EdgeInsets.zero,
                      height: 200,
                      width: 300,
                      child: Center(
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .certificatePage_certificateOf,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 08,
                                        color: const Color.fromARGB(
                                            255, 207, 33, 21)),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .certificatePage_savingContribution,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 10,
                                        color: const Color.fromARGB(
                                            255, 207, 33, 21),
                                        fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                user.userName,
                                style: const TextStyle().copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .certificatePage_selfnessContibutionq,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 30,
                      child: Image(
                        width: 150,
                        alignment: Alignment.topCenter,
                        image: AssetImage(kIsWeb
                            ? 'images/certificate/certificate_left.png'
                            : 'assets/images/certificate/certificate_left.png'),
                      ),
                    ),
                    const Positioned(
                      top: 30,
                      right: 0,
                      child: Image(
                        width: 150,
                        alignment: Alignment.topCenter,
                        image: AssetImage(kIsWeb
                            ? 'images/certificate/certificate_right.png'
                            : 'assets/images/certificate/certificate_right.png'),
                      ),
                    ),
                    const Positioned(
                      top: -10,
                      left: -10,
                      child: Image(
                        width: 320,
                        alignment: Alignment.topCenter,
                        image: AssetImage(kIsWeb
                            ? 'images/certificate/certificate_header.png'
                            : 'assets/images/certificate/certificate_header.png'),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .certificatePage_iDonateLife,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .certificatePage_bloodDonation,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        )),
                    const Positioned(
                      top: 05,
                      child: Image(
                        width: 70,
                        alignment: Alignment.topCenter,
                        image: AssetImage(kIsWeb
                            ? 'images/certificate/certificate_badge.png'
                            : 'assets/images/certificate/certificate_badge.png'),
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .certificatePage_date,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                        fontSize: 10,
                                      ),
                                  children: [
                                    TextSpan(
                                        text: DateFormatter.formateDateToString(
                                            DateTime.now()))
                                  ],
                                ),
                              ),
                              const Image(
                                width: 40,
                                image: AssetImage(kIsWeb
                                    ? 'images/certificate/certificate_i_donate_life_signature.png'
                                    : 'assets/images/certificate/certificate_i_donate_life_signature.png'),
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _shareCertificate,
              label: Text(AppLocalizations.of(context)!.certificatePage_share),
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }
}
