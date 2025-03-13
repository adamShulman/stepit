
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stepit/classes/database.dart';
import 'package:stepit/l10n/app_localizations.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/services/dialog_service.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/app_bar.dart';
import 'package:stepit/widgets/background_gradient_container.dart';

class IdentificationPage extends StatefulWidget {

  const IdentificationPage({ super.key });

  @override
  State createState() => _IdentificationPageState();

}

class _IdentificationPageState extends State<IdentificationPage> {

  int? _uniqueNumber;
  late String _gameType;

  final TextEditingController _usernameTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gameType = _generateGameType();
  }

  Future<int> _generateUniqueNumber() async {
    // return the number of user in the database
    return await DataBase.getNumberOfUsers();
  }


  String _generateGameType()  {
    if(Random().nextInt(2) == 0) {
      return 'Challenge';
    }
    return 'Influence';
  }

  void _showDialogMessage(String message) {
    DialogService().showSingleDialog(context, AppLocalizations.of(context)!.identificationTitle, message);
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text(AppLocalizations.of(context)!.identificationTitle),
    //     content: Text(message),
    //     actions: <Widget>[
    //       TextButton(
    //         style: const ButtonStyle(
    //           elevation: WidgetStatePropertyAll(4.0),
    //           backgroundColor: WidgetStatePropertyAll(Color(0xFFC7F9CC))
    //         ),
    //         child: const Text(
    //           'OK',
    //           style: TextStyle(
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
  }

  Future<void> _saveAndNavigateHome() async {

    try {

      bool isSaved = await _saveToFirestore();

      if (mounted && isSaved) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }

    } catch (e) {
      dev.log("Error during async tasks: $e");
    }
  }

  Future<bool> _saveToFirestore() async {

    if (_uniqueNumber == null) {
      _showDialogMessage(AppLocalizations.of(context)!.uniqueNumberGetError);
      return false;
    }

    final String? userNameValidationMessage = validateUsername(_usernameTextFieldController.text);

    if (userNameValidationMessage != null) {
      _showDialogMessage(userNameValidationMessage);
      return false;
    }

    await saveUser(_usernameTextFieldController.text, _uniqueNumber!, _gameType, 1, 0);
    return true;
  }

  String? validateUsername(String? value) {

    final patternMessage = AppLocalizations.of(context)!.userNameRegexMessage;

    if (value == null || value.isEmpty) {
      return patternMessage;
    }

    final emailRegex = RegExp(
      r'^[0-9A-Za-z]{4,16}$',
      caseSensitive: false,
    );

    return emailRegex.hasMatch(value) ? null : patternMessage;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: StepItAppBar(
        title: AppLocalizations.of(context)!.welcomeTo,
      ),
      body: BackgroundGradientContainer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsetsDirectional.symmetric(vertical: 0.0, horizontal: 6.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.enterUserName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Image.asset(
                      "assets/images/stepit_logo_foreground.png",
                      height: 50.0,
                      width: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.username],
                        
                        controller: _usernameTextFieldController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: GeneralUtils.formStandardDecoration('username'),
                      ),
                    ),
                    FutureBuilder<int>(
                      future: _generateUniqueNumber(),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(AppLocalizations.of(context)!.loadingUniqueNumber);
                        } else {
                          if (snapshot.data != null) {
                            final userIdentifier = snapshot.data!;
                            _uniqueNumber = userIdentifier;
                            return Text('${AppLocalizations.of(context)!.uniqueNumber} ${userIdentifier.toString().padLeft(6, '0')}');
                          } else {
                            return Text(AppLocalizations.of(context)!.uniqueNumberNotFound);
                          }
                          
                        }
                      },
                    ),
                  ],
                )
              )
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () => _saveAndNavigateHome(),
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: const TextStyle(
                    color: Colors.black
                  ),
                ),
              ),
            )
          ],
          ),
        ),
      )
    );
  }
}
