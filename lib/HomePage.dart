import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

  String _fromLanguage = 'ar';
  String _toLanguage = 'en';
  bool _isSwapped = false;

  @override
  void initState() {
    _translation = Translation(
      apiKey: 'YOUR_API_KEY',
    );
    super.initState();
  }

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();

  void speak(TextEditingController controller, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.speak(controller.text);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
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
                      FocusManager.instance.primaryFocus?.unfocus();

                      setState(() {
                        _translatedController.text = _translated.translatedText;
                      });
                    } catch (e) {
                      print("Translation Error: $e");
                    }
                  },
                  showTranslateButton: true,
                  language: _fromLanguage == 'ar' ? 'Arabic' : 'English',
                  onClear: () {
                    _controller.clear();
                  },
                  onSpeak: () => speak(_controller, _fromLanguage),
                ),
                SizedBox(height: 60),
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
                  },
                  language: _toLanguage == 'ar' ? 'Arabic' : 'English',
                  showTranslateButton: false,
                  onClear: () {
                    _translatedController.clear();
                  },
                  onSpeak: () => speak(_translatedController, _toLanguage),
                ),
                SizedBox(height: 40),
                CreatedByKerlos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreatedByKerlos extends StatelessWidget {
  const CreatedByKerlos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("created by "),
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse('https://github.com/kerlosatef'));
          },
          child: Text("@Kerlos_atef",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
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
              width: 35,
              height: 35,
              child: Image.asset(
                  isSwapped ? 'assets/flags/Egypt.png' : 'assets/flags/UK.png'),
            ),
            SizedBox(width: 1),
            Text(
              isSwapped ? 'Arabic' : 'English',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(width: 40),
            GestureDetector(
              onTap: onSwapPressed,
              child: SvgPicture.asset('assets/icons/swap.svg', height: 25),
            ),
            SizedBox(width: 40),
            Text(
              isSwapped ? 'English' : 'Arabic',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(width: 1),
            Container(
              width: 35,
              height: 35,
              child: Image.asset(
                  isSwapped ? 'assets/flags/UK.png' : 'assets/flags/Egypt.png'),
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
