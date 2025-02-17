import 'dart:convert';
import 'widgets/custom_form_field.dart';
import 'package:cssapp/configs/configs.dart';
import 'package:cssapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportBugs extends StatefulWidget {
  const ReportBugs({Key? key}) : super(key: key);

  @override
  State<ReportBugs> createState() => _ReportBugsState();
}

class _ReportBugsState extends State<ReportBugs> {
  bool isLoading = false;
  String? errorText;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  Future<String?> sendEmail() async {
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      String name = nameController.text;
      String email = emailController.text.trim();
      String subject = subjectController.text;
      String message = messageController.text;
      const serviceId = "service_rvef4wd";
      const templateId = "template_ifh1o4d";
      const userId = "CVD052yKVtaMl2d4n";
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            "service_id": serviceId,
            "template_id": templateId,
            "user_id": userId,
            "template_params": {
              "name": name,
              "email": email,
              "subject": subject,
              "message": message
            }
          }));
      print(response.statusCode);
    } catch (e) {
      return e.toString();
    }
  }

  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        content: const Text("Thanks For Your Feedback!",
            style: TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.greenAccent.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(8, 25, 0, 0),
          child: Builder(builder: (context) {
            return FloatingActionButton(
                elevation: 12,
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).canvasColor,
                  size: 33,
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                onPressed: () {
                  Navigator.pop(context);
                });
          }),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              const CSSBGText(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      child: Column(
                        children: [
                          CustomFormField(
                              controller: nameController,
                              labelText: 'Name(optional)',
                              icon: Icons.account_circle),
                          const SizedBox(height: 25),
                          CustomFormField(
                            controller: emailController,
                            labelText: 'Email Address',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 25),
                          CustomFormField(
                            controller: subjectController,
                            labelText: 'Subject',
                            icon: Icons.subject,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomFormField(
                            controller: messageController,
                            labelText: 'Your message',
                            icon: Icons.message,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (emailController.text.isEmpty ||
                                  subjectController.text.isEmpty ||
                                  messageController.text.isEmpty) {
                                setState(() {
                                  errorText = "Please fill all fields!";
                                });
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                sendEmail().then((String? err) => setState(() {
                                      errorText = err;
                                      isLoading = false;
                                      if (err == null) {
                                        nameController.clear();
                                        emailController.clear();
                                        subjectController.clear();
                                        messageController.clear();
                                        _showToast(ctx);
                                      }
                                    }));
                              }
                            },
                            child: isLoading
                                ? const SizedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                    height: 15,
                                    width: 15,
                                  )
                                : Text(
                                    "Send Message",
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: <Widget>[
                              errorText != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              errorText!,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 35),
                          SizedBox(
                            width: 300,
                            child: Text(
                              "Diclaimer: Reporting to CSS must be formal. Here, you can register ideas and suggestions for the website and everything CSS. Please avoid unnecessary messages and spams. Strict actions will be taken against those violating these rules.",
                              style: textSmall.copyWith(
                                  height: 1.2,
                                  color: Theme.of(context).backgroundColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
