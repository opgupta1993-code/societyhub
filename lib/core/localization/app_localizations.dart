import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'SocietyHub',
      'sub_title': 'Complete Gated Community Management',
      'login_title': 'Login to Your Account',
      'enter_mobile_sub': 'Enter your registered mobile number to receive OTP',
      'enter_otp_sub': 'Enter the verification code sent to your mobile',
      'mobile_number': 'Mobile Number',
      'request_otp': 'Request OTP',
      'verify_login': 'Verify & Login',
      'resend_otp': 'Resend OTP',
      'change_number': 'Change Number',
      'no_account': "Don't have an account? ",
      'register_now': 'Register Now',
      'register_title': 'Join Your Society Community',
      'full_name': 'Full Name',
      'society_name': 'Society Name',
      'flat_number': 'Flat / Unit Number',
      'owner': 'Owner',
      'tenant': 'Tenant',
      'complete_register': 'Complete Registration',
      'switch_language': 'Language / भाषा',
      'notifications': 'Notifications',
      'profile': 'My Profile',
      'logout': 'Logout',
      'quick_actions': 'Quick Actions',
      'pending_dues': 'Pending Dues',
      'gate_passes': 'Gate Passes',
      'complaints': 'Complaints',
      'notices': 'Notices',
      'polls': 'Polls & Voting',
      'amenity_booking': 'Amenity Booking',
      'records_hub': 'My Records Hub',
      'directory': 'Society Directory',
    },
    'hi': {
      'app_title': 'सोसायटीहब',
      'sub_title': 'संपूर्ण सोसायटी प्रबंधन ऐप',
      'login_title': 'अपने खाते में लॉगिन करें',
      'enter_mobile_sub': 'ओटीपी प्राप्त करने के लिए अपना पंजीकृत मोबाइल नंबर दर्ज करें',
      'enter_otp_sub': 'अपने मोबाइल पर भेजा गया सत्यापन कोड दर्ज करें',
      'mobile_number': 'मोबाइल नंबर',
      'request_otp': 'ओटीपी भेजें',
      'verify_login': 'सत्यापित करें और लॉगिन करें',
      'resend_otp': 'पुनः ओटीपी भेजें',
      'change_number': 'नंबर बदलें',
      'no_account': 'क्या आपका खाता नहीं है? ',
      'register_now': 'अभी पंजीकरण करें',
      'register_title': 'अपनी सोसायटी समुदाय से जुड़ें',
      'full_name': 'पूरा नाम',
      'society_name': 'सोसायटी का नाम',
      'flat_number': 'फ्लैट / विंग नंबर',
      'owner': 'मकान मालिक (Owner)',
      'tenant': 'किराएदार (Tenant)',
      'complete_register': 'पंजीकरण पूरा करें',
      'switch_language': 'भाषा बदलें (Language)',
      'notifications': 'सूचनाएं',
      'profile': 'मेरी प्रोफाइल',
      'logout': 'लॉगआउट',
      'quick_actions': 'त्वरित कार्य',
      'pending_dues': 'बकाया शुल्क',
      'gate_passes': 'गेट पास',
      'complaints': 'शिकायतें',
      'notices': 'सूचना पट्ट',
      'polls': 'मतदान (Polls)',
      'amenity_booking': 'सुविधा बुकिंग',
      'records_hub': 'मेरे रिकॉर्ड्स',
      'directory': 'सोसायटी डायरेक्टरी',
    },
    'mr': {
      'app_title': 'सोसायटीहब',
      'sub_title': 'संपूर्ण सोसायटी व्यवस्थापन अॅप',
      'login_title': 'आपल्या खात्यात लॉग इन करा',
      'enter_mobile_sub': 'OTP मिळवण्यासाठी तुमचा नोंदणीकृत मोबाईल नंबर टाका',
      'enter_otp_sub': 'मोबाईलवर आलेला पडताळणी कोड टाका',
      'mobile_number': 'मोबाईल नंबर',
      'request_otp': 'OTP पाठवा',
      'verify_login': 'पडताळणी करा आणि लॉगिन करा',
      'resend_otp': 'पुन्हा OTP पाठवा',
      'change_number': 'नंबर बदला',
      'no_account': 'खाते नाही का? ',
      'register_now': 'आत्ताच नोंदणी करा',
      'register_title': 'आपल्या सोसायटी समुदायात सामील व्हा',
      'full_name': 'पूर्ण नाव',
      'society_name': 'सोसायटीचे नाव',
      'flat_number': 'फ्लॅट / विंग नंबर',
      'owner': 'मालक (Owner)',
      'tenant': 'भाडेकरू (Tenant)',
      'complete_register': 'नोंदणी पूर्ण करा',
      'switch_language': 'भाषा निवडा',
      'notifications': 'सूचना',
      'profile': 'माझी प्रोफाईल',
      'logout': 'लॉगआउट',
      'quick_actions': 'जलद कृती',
      'pending_dues': 'बाकी शुल्क',
      'gate_passes': 'गेट पास',
      'complaints': 'तक्रारी',
      'notices': 'सूचना फलक',
      'polls': 'मतदान (Polls)',
      'amenity_booking': 'सुविधा बुकिंग',
      'records_hub': 'माझे रेकॉर्ड्स',
      'directory': 'सोसायटी डिरेक्टरी',
    },
    'gu': {
      'app_title': 'સોસાયટીહબ',
      'sub_title': 'સંપૂર્ણ સોસાયટી મેનેજમેન્ટ એપ્લિકેશન',
      'login_title': 'તમારા એકાઉન્ટમાં લૉગિન કરો',
      'enter_mobile_sub': 'OTP મેળવવા માટે તમારો મોબાઈલ નંબર દાખલ કરો',
      'enter_otp_sub': 'મોબાઈલ પર મોકલેલ ચકાસણી કોડ દાખલ કરો',
      'mobile_number': 'મોબાઈલ નંબર',
      'request_otp': 'OTP મેળવો',
      'verify_login': 'ચકાસો અને લૉગિન કરો',
      'resend_otp': 'ફરીથી OTP મોકલો',
      'change_number': 'નંબર બદલો',
      'no_account': 'એકાઉન્ટ નથી? ',
      'register_now': 'હમણાં જ નોંધણી કરો',
      'register_title': 'તમારી સોસાયટી સમુદાયમાં જોડાઓ',
      'full_name': 'પૂરું નામ',
      'society_name': 'સોસાયટીનું નામ',
      'flat_number': 'ફ્લેટ / વિંગ નંબર',
      'owner': 'માલિક (Owner)',
      'tenant': 'ભાડૂઆત (Tenant)',
      'complete_register': 'નોંધણી પૂર્ણ કરો',
      'switch_language': 'ભાષા પસંદ કરો',
      'notifications': 'સૂચનાઓ',
      'profile': 'મારી પ્રોફાઇલ',
      'logout': 'લૉગઆઉટ',
      'quick_actions': 'ઝડપી પ્રક્રિયાઓ',
      'pending_dues': 'બાકી ચૂકવણી',
      'gate_passes': 'ગેટ પાસ',
      'complaints': 'ફરિયાદો',
      'notices': 'નોટિસ બોર્ડ',
      'polls': 'મતદાન (Polls)',
      'amenity_booking': 'સુવિધા બુકિંગ',
      'records_hub': 'મારા રેકોર્ડ્સ',
      'directory': 'સોસાયટી ડિરેક્ટરી',
    }
  };

  String tr(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr', 'gu'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void changeLocale(String languageCode) {
    state = Locale(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this).tr(key);
  }
}
