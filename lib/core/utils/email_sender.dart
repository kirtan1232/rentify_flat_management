// lib/core/utils/email_sender.dart
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail({
  required String content,
  required String subject,
}) async {
  // Gmail SMTP configuration
  String username = 'rentify20@gmail.com'; // Replace with your Gmail
  String password = 'fwob affj opny icen'; // Replace with your App Password

  final smtpServer = gmail(username, password);

  // Create email message
  final message = Message()
    ..from = Address(username, 'Rentify User')
    ..recipients.add('rentify20@gmail.com')
    ..subject = subject
    ..text = content;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
    throw Exception('Failed to send: $e');
  }
}
