import 'package:flutter/material.dart';
import 'package:myapp/features/Faq/presentation/data/faq_data.dart';
import 'package:myapp/features/Faq/presentation/widgets/faq.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FaqPage extends StatelessWidget {
  FaqPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<FaqModel> faqs = getData(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.faqData_appBar),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) => EasyFaq(
              question: faqs[index].question, answer: faqs[index].answer),
          itemCount: faqs.length,
        ),
      ),
    );
  }
}
