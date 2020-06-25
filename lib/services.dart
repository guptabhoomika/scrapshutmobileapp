import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class Services
{
 static sendmail(String body) async
  {
    final MailOptions mailOptions = MailOptions(
  body: body,
  subject: 'Error Report',
  recipients: ['mounikesh@scrapshut.com','duckyoubug@scrapshut.com'],
  isHTML: true,
 
  //ccRecipients: ['ayushagr2000@gmail.com'],
  
);

await FlutterMailer.send(mailOptions);

  }
}