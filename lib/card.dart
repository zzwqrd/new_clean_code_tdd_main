import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareTextExample extends StatelessWidget {
  final String message = 'This is a sample text message to share';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share Text Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                shareTextOnWhatsApp();
              },
              child: Text('Send Text on WhatsApp'),
            ),
            ElevatedButton(
              onPressed: () {
                shareTextOnMessenger();
              },
              child: Text('Send Text on Messenger'),
            ),
          ],
        ),
      ),
    );
  }

  // مشاركة النص على واتساب
  Future<void> shareTextOnWhatsApp() async {
    final Uri whatsappUri =
        Uri.parse("whatsapp://send?phone=&text=${Uri.encodeFull(message)}");

    // تحقق مما إذا كان يمكن إطلاق الرابط
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      // إذا لم يكن واتساب مثبتًا، أعرض رسالة أو استخدم طريقة بديلة
      print("WhatsApp is not installed or the URI is incorrect");
      showErrorDialog("WhatsApp is not installed or the URI is incorrect.");
    }
  }

  // مشاركة النص على ماسنجر
  Future<void> shareTextOnMessenger() async {
    final Uri messengerUri =
        Uri.parse("fb-messenger://share?link=${Uri.encodeFull(message)}");

    if (await canLaunchUrl(messengerUri)) {
      await launchUrl(messengerUri);
    } else {
      // إذا لم يكن ماسنجر مثبتًا، استخدم رابط بديل على الويب
      const fallbackUrl = "https://www.messenger.com";
      if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
        await launchUrl(Uri.parse(fallbackUrl));
      } else {
        throw 'Could not launch Messenger';
      }
    }
  }

  // عرض رسالة خطأ عند الفشل
  void showErrorDialog(String message) {
    // يمكنك استخدام Dialog أو SnackBar لعرض رسالة
    print(message);
  }
}
