import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stepit/l10n/app_localizations.dart';
import 'package:stepit/pages/identification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/services/dialog_service.dart';
import 'package:stepit/widgets/app_bar.dart';
import 'package:stepit/widgets/background_gradient_container.dart';

class AgreementPage extends StatefulWidget {

  const AgreementPage({ super.key });
  
  @override
  State createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {

  bool _agreed = false;

  Future<void> _saveAndNavigateToIdentification() async {

    if (_agreed == false) {
      final message = AppLocalizations.of(context)!.termsBeforeProceed;
      DialogService().showSingleDialog(context, AppLocalizations.of(context)!.termsTitle, message);
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text(AppLocalizations.of(context)!.termsTitle),
      //     content: Text(message),
      //     actions: <Widget>[
      //       TextButton(
      //         style: const ButtonStyle(
      //           elevation: WidgetStatePropertyAll(4.0),
      //           backgroundColor: WidgetStatePropertyAll(Color(0xFFC7F9CC))
      //         ),
      //         child: Text(
      //           AppLocalizations.of(context)!.ok,
      //           style: const TextStyle(
      //             color: Colors.black
      //           ),
      //         ),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //       ),
      //     ],
      //   ),
      // );
      return ;
    }

    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('first_time', false);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IdentificationPage()),
        );
      }

    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepItAppBar(
        title: AppLocalizations.of(context)!.termsTitle,
      ),
      body: BackgroundGradientContainer(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeTo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsetsDirectional.symmetric(vertical: 0.0, horizontal: 6.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Text(
                        'This Agreement is entered into by and between the user, hereinafter referred to as "User", '
                        'and Stepit, hereinafter referred to as "Company". \n\n'
                        '1. Terms and Conditions: User agrees to abide by all terms and conditions of this Agreement, '
                        'as well as any additional terms and conditions presented by the Company.\n '
                        '2. Privacy: User acknowledges and agrees that the Company may collect and use personal information '
                        'from the User in accordance with the Company\'s privacy policy.\n '
                        '3. Intellectual Property: User acknowledges and agrees that all content provided by the Company '
                        'is the intellectual property of the Company and is protected by copyright, trademark, and other laws.\n '
                        '4. Limitation of Liability: User acknowledges and agrees that the Company will not be liable for '
                        'any direct, indirect, incidental, special, consequential or exemplary damages, including but not limited '
                        'to, damages for loss of profits, goodwill, use, data or other intangible losses resulting from the use of '
                        'or inability to use the service.\n '
                        '5. Termination: User acknowledges and agrees that the Company may terminate this Agreement at any time '
                        'for any reason, including but not limited to, breach of this Agreement by the User. '
                        '6. Governing Law: This Agreement shall be governed by and construed in accordance with the laws of the '
                        'jurisdiction in which the Company is located. \n'
                        'By using the services provided by the Company, the User agrees to be bound by this Agreement. '
                        'If the User does not agree to abide by the terms of this Agreement, the User is not authorized to use '
                        'or access the services provided by the Company.',
                        softWrap: true,
                      ),
                    ),
                  )
                )
                 
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                    value: _agreed,
                    side: const BorderSide(color: Colors.white),
                    onChanged: (bool? value) {
                      setState(() {
                        _agreed = value ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.agreeToTerms,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                  
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  onPressed: () => _saveAndNavigateToIdentification(),
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                  ),
                ),
              )
              
            ],
          ),
        )
      )
    );
  }
}
