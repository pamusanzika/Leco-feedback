import 'package:flutter/material.dart';

class AppColors {
  static const Color lecoYellow = Color(0xFFFCE447);
  static const Color canvas = Color(0xFFFAFAF7);
  static const Color ink = Color(0xFF111111);
  static const Color muted = Color(0xFF6B6B6B);
}

class AppCopy {
  const AppCopy({
    required this.brandTitle,
    required this.brandSubtitle,
    required this.branchPrefix,
    required this.quickFeedback,
    required this.heading,
    required this.description,
    required this.submit,
    required this.poweredBy,
    required this.productName,
    required this.version,
    required this.counterPrefix,
    required this.counterFallback,
    required this.loading,
    required this.thankYouTitle,
    required this.thankYouMessage,
    required this.queueIdLabel,
    required this.closingIn,
    required this.secondsSuffix,
    required this.veryGood,
    required this.veryGoodSubtitle,
    required this.good,
    required this.goodSubtitle,
    required this.okay,
    required this.okaySubtitle,
    required this.bad,
    required this.badSubtitle,
    required this.veryBad,
    required this.veryBadSubtitle,
  });

  final String brandTitle;
  final String brandSubtitle;
  final String branchPrefix;
  final String quickFeedback;
  final String heading;
  final String description;
  final String submit;
  final String poweredBy;
  final String productName;
  final String version;
  final String counterPrefix;
  final String counterFallback;
  final String loading;
  final String thankYouTitle;
  final String thankYouMessage;
  final String queueIdLabel;
  final String closingIn;
  final String secondsSuffix;
  final String veryGood;
  final String veryGoodSubtitle;
  final String good;
  final String goodSubtitle;
  final String okay;
  final String okaySubtitle;
  final String bad;
  final String badSubtitle;
  final String veryBad;
  final String veryBadSubtitle;

  static AppCopy of(String language) {
    switch (language.toLowerCase()) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      case 'en':
      default:
        return en;
    }
  }

  static const en = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'Customer feedback',
    branchPrefix: 'Branch',
    quickFeedback: 'Quick feedback',
    heading: 'How did we\ndo today?',
    description:
        'Your honest rating helps us improve our service at every counter.',
    submit: 'Submit',
    poweredBy: 'Powered by',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'Counter',
    counterFallback: 'v2.4 · Counter --',
    loading: 'Loading',
    thankYouTitle: 'Thank you!',
    thankYouMessage: 'Your feedback has been recorded successfully.',
    queueIdLabel: 'Queue ID',
    closingIn: 'Closing in',
    secondsSuffix: 's',
    veryGood: 'Very good',
    veryGoodSubtitle: 'Excellent - thank you!',
    good: 'Good',
    goodSubtitle: 'A pleasant experience.',
    okay: 'Okay',
    okaySubtitle: 'Service was alright.',
    bad: 'Bad',
    badSubtitle: 'Below expectations.',
    veryBad: 'Very bad',
    veryBadSubtitle: "We need to do better - we're sorry.",
  );

  static const si = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'පාරිභෝගික ප්‍රතිචාර',
    branchPrefix: 'ශාඛාව',
    quickFeedback: 'කෙටි ප්‍රතිචාර',
    heading: 'අද අපගේ\nසේවාව කොහොමද?',
    description: 'ඔබගේ අවංක ඇගයීම අපගේ සේවාව වැඩි දියුණු කිරීමට උපකාරී වේ.',
    submit: 'යවන්න',
    poweredBy: 'බලගැන්වීම',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'කවුන්ටරය',
    counterFallback: 'v2.4 · කවුන්ටරය --',
    loading: 'පූරණය වෙමින්',
    thankYouTitle: 'ස්තූතියි!',
    thankYouMessage: 'ඔබගේ ප්‍රතිචාරය සාර්ථකව සටහන් විය.',
    queueIdLabel: 'පෝලිම් අංකය',
    closingIn: 'වසා දමන්නේ තත්පර',
    secondsSuffix: '',
    veryGood: 'ඉතා හොඳයි',
    veryGoodSubtitle: 'විශිෂ්ටයි - ස්තූතියි!',
    good: 'හොඳයි',
    goodSubtitle: 'සතුටුදායක අත්දැකීමක්.',
    okay: 'සාමාන්‍යයි',
    okaySubtitle: 'සේවාව සාමාන්‍ය මට්ටමේ විය.',
    bad: 'අඩුයි',
    badSubtitle: 'අපේක්ෂාවට අඩුයි.',
    veryBad: 'ඉතා අඩුයි',
    veryBadSubtitle: 'අපි තවත් හොඳ කළ යුතුයි.',
  );

  static const ta = AppCopy(
    brandTitle: 'LECO',
    brandSubtitle: 'வாடிக்கையாளர் கருத்து',
    branchPrefix: 'கிளை',
    quickFeedback: 'விரைவு கருத்து',
    heading: 'இன்று எங்கள்\nசேவை எப்படி?',
    description:
        'உங்கள் நேர்மையான மதிப்பீடு எங்கள் சேவையை மேம்படுத்த உதவுகிறது.',
    submit: 'சமர்ப்பிக்க',
    poweredBy: 'வழங்கியது',
    productName: 'LECO Digital',
    version: 'v2.4',
    counterPrefix: 'கவுண்டர்',
    counterFallback: 'v2.4 · கவுண்டர் --',
    loading: 'ஏற்றுகிறது',
    thankYouTitle: 'நன்றி!',
    thankYouMessage: 'உங்கள் கருத்து வெற்றிகரமாக பதிவு செய்யப்பட்டது.',
    queueIdLabel: 'வரிசை ID',
    closingIn: 'மூடப்படும் நேரம்',
    secondsSuffix: 's',
    veryGood: 'மிகவும் நல்லது',
    veryGoodSubtitle: 'சிறப்பு - நன்றி!',
    good: 'நல்லது',
    goodSubtitle: 'இனிய அனுபவம்.',
    okay: 'சரி',
    okaySubtitle: 'சேவை சரியாக இருந்தது.',
    bad: 'மோசம்',
    badSubtitle: 'எதிர்பார்ப்புக்கு குறைவு.',
    veryBad: 'மிக மோசம்',
    veryBadSubtitle: 'நாங்கள் இன்னும் மேம்பட வேண்டும்.',
  );
}
