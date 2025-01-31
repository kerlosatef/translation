import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:translation/text_field.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Translation _translation;
  TranslationModel _translated =
      TranslationModel(translatedText: '', detectedSourceLanguage: '');
  TranslationModel _detected =
      TranslationModel(translatedText: '', detectedSourceLanguage: '');

  String _fromLanguage = 'ar'; // Default from Arabic
  String _toLanguage = 'en'; // Default to English
  bool _isSwapped = false;

  @override
  void initState() {
    _translation = Translation(
      apiKey: 'Your_API_Key',
    );
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: languageSwap(
                  onSwapPressed: () {
                    setState(() {
                      _isSwapped = !_isSwapped;
                      final temp = _fromLanguage;
                      _fromLanguage = _toLanguage;
                      _toLanguage = temp;

                      final tempText = _controller.text;
                      _controller.text = _translatedController.text;
                      _translatedController.text = tempText;
                    });
                  },
                  isSwapped: _isSwapped,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              textfield(
                  hintText: 'Enter text...',
                  controller: _controller,
                  translateIcon: 'assets/icons/translate.svg',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _controller.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Text copied to clipboard'),
                      ),
                    );
                  },
                  onPressed: () async {
                    String enteredText = _controller.text;
                    try {
                      _translated = await _translation.translate(
                        text: enteredText,
                        to: _toLanguage,
                      );

                      setState(() {
                        _translatedController.text = _translated.translatedText;
                      });
                    } catch (e) {
                      print("Translation Error: $e");
                    }
                  }),
              SizedBox(height: 100),
              textfield(
                  hintText: 'Translate... ',
                  controller: _translatedController,
                  translateIcon: '',
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: _translatedController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Text copied to clipboard'),
                      ),
                    );
                  }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("created by "),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse('https://github.com/kerlosatef'));
                    },
                    child: Text("@Kerlos_atef",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class languageSwap extends StatelessWidget {
  final VoidCallback onSwapPressed;
  final bool isSwapped;

  const languageSwap({
    super.key,
    required this.onSwapPressed,
    required this.isSwapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 30,
              height: 30,
              child: Image.asset(
                  isSwapped ? 'assets/flags/Egypt.png' : 'assets/flags/UK.png'),
            ),
            SizedBox(width: 1),
            Text(
              isSwapped ? 'Ar' : 'Eng',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 50),
            GestureDetector(
              onTap: onSwapPressed,
              child: SvgPicture.asset('assets/icons/swap.svg', height: 20),
            ),
            SizedBox(width: 60),
            Container(
              width: 30,
              height: 30,
              child: Image.asset(
                  isSwapped ? 'assets/flags/UK.png' : 'assets/flags/Egypt.png'),
            ),
            SizedBox(width: 1),
            Text(
              isSwapped ? 'Eng' : 'Ar',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(94, 62, 214, 1),
            Color.fromRGBO(96, 60, 214, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
