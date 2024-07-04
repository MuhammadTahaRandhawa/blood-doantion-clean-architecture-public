import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<FaqModel> getData(BuildContext context) {
  List<FaqModel> faqData = [
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes1,
        answer: AppLocalizations.of(context)!.faqData_ans1),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes2,
        answer: AppLocalizations.of(context)!.faqData_ans2),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes3,
        answer: AppLocalizations.of(context)!.faqData_ans3),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes4,
        answer: AppLocalizations.of(context)!.faqData_ans4),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes5,
        answer: AppLocalizations.of(context)!.faqData_ans5),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes6,
        answer: AppLocalizations.of(context)!.faqData_ans6),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes7,
        answer: AppLocalizations.of(context)!.faqData_ans7),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes8,
        answer: AppLocalizations.of(context)!.faqData_ans8),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes9,
        answer: AppLocalizations.of(context)!.faqData_ans9),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes10,
        answer: AppLocalizations.of(context)!.faqData_ans10),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes11,
        answer: AppLocalizations.of(context)!.faqData_ans11),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes12,
        answer: AppLocalizations.of(context)!.faqData_ans12),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes13,
        answer: AppLocalizations.of(context)!.faqData_ans13),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes14,
        answer: AppLocalizations.of(context)!.faqData_ans14),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes15,
        answer: AppLocalizations.of(context)!.faqData_ans15),
    FaqModel(
        question: AppLocalizations.of(context)!.faqData_qes16,
        answer: AppLocalizations.of(context)!.faqData_ans16),
  ];

  return faqData;
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({required this.question, required this.answer});
}
