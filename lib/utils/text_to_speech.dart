import 'package:ar/constant/medoc.dart';
import 'package:ar/provider/app_provider.dart';
import 'package:html/parser.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

void text_to_speech(String code) {
  TextToSpeech tts = TextToSpeech();
  String language = 'fr';
  tts.setLanguage(language);
  double volume = 1.0;
  tts.setVolume(volume);
  String text = medoc[code]["mode d'emploi et posologie"];
/*   String text =
      "pingbin ni baka n’ga be nian gnan man afouè blou ni nou bé kloua fa man aré n’ga. Bé fè min pè koun ba.sè vié liè ô kô bo yôya a kloi fa. A réma n’ga beho nou bé non bé ni n’zoué , i koussou a kloi min koun n'glin mi koun midi sou  koun n'do soua"; */
  tts.speak(text);
}

void text_to_recommend() {
  TextToSpeech tts = TextToSpeech();
  String language = 'fr';
  tts.setLanguage(language);
  double volume = 1.0;
  tts.setVolume(volume);
  String text = "Médicament non recommandé";
/*   String text =
      "pingbin ni baka n’ga be nian gnan man afouè blou ni nou bé kloua fa man aré n’ga. Bé fè min pè koun ba.sè vié liè ô kô bo yôya a kloi fa. A réma n’ga beho nou bé non bé ni n’zoué , i koussou a kloi min koun n'glin mi koun midi sou  koun n'do soua"; */
  tts.speak(text);
}

void text_to_speech_tradional(String code) {
  TextToSpeech tts = TextToSpeech();
  String language = 'fr';
  tts.setLanguage(language);
  double volume = 1.0;
  tts.setVolume(volume);
  String text = medoc[code]["mode d'emploi et posologie"];
/*   String text =
      "pingbin ni baka n’ga be nian gnan man afouè blou ni nou bé kloua fa man aré n’ga. Bé fè min pè koun ba.sè vié liè ô kô bo yôya a kloi fa. A réma n’ga beho nou bé non bé ni n’zoué , i koussou a kloi min koun n'glin mi koun midi sou  koun n'do soua"; */
  tts.speak(text);
}

Future<Map?> startScan(int option, String medoc) async {
  var data = {};

  return goodValue(medoc).then((value) async {
    if (value == "null") {
      startScan(2, value);
    } else {
      String url = 'https://www.doctissimo.fr/medicament-$value.htm';
      final translator = GoogleTranslator();
      final response = await http.get(Uri.parse(url));
      final body = response.body;
      final html = parse(body);

      final indication = html.querySelector("#collapseIndication")?.text.trim();
      final posologie = html.querySelector("#collapseDosage")?.text.trim();
      final effet = html.querySelector("#collapseEffect")?.text.trim();
      final cIndication = html.querySelector("#collapseCI")?.text.trim();
      final precaution = html.querySelector("#collapsePrecaution")?.text.trim();
      final interaction =
          html.querySelector("#collapseInteraction")?.text.trim();
      final surdosage = html.querySelector("#collapseSurdosage")?.text.trim();
      final grossesse = html.querySelector("#collapseGrossesse")?.text.trim();

      var lang = 'fr';

      if (option == 2) {
        lang = 'en';
      }

      if (option == 3) {
        lang = 'es';
      }

      if (option == 4) {
        lang = 'fr';
      }

      final indication_trans =
          await translator.translate(indication!, from: 'fr', to: lang);
      final posologie_trans =
          await translator.translate(posologie!, from: 'fr', to: lang);
      final effet_trans =
          await translator.translate(effet!, from: 'fr', to: lang);
      final cIndication_trans =
          await translator.translate(cIndication!, from: 'fr', to: lang);
      final precaution_trans =
          await translator.translate(precaution!, from: 'fr', to: lang);
      final interaction_trans =
          await translator.translate(interaction!, from: 'fr', to: lang);
      final surdosage_trans =
          await translator.translate(surdosage!, from: 'fr', to: lang);
      final grossesse_trans =
          await translator.translate(grossesse!, from: 'fr', to: lang);

      var baoule =
          "pingbin ni baka n’ga be nian gnan man afouè blou ni nou bé kloua fa man aré n’ga. Bé fè min pè koun ba.sè vié liè ô kô bo yôya a kloi fa. A réma n’ga beho nou bé non bé ni n’zoué , i koussou a kloi min koun n'glin mi koun midi sou  koun n'do soua";

      if (option == 4) {
        data = {
          'Indication': baoule,
          'posologie': '',
          'effet': '',
          'Contre_indication': '',
          'precaution': '',
          'interaction': '',
          'surdosage': '',
          'grossesse': '',
          'langue': lang
        };

        logger.d(data['Indication']);
        logger.d(option);
      } else {
        data = {
          'Indication': indication_trans,
          'posologie': posologie_trans,
          'effet': effet_trans,
          'Contre_indication': cIndication_trans,
          'precaution': precaution_trans,
          'interaction': interaction_trans,
          'surdosage': surdosage_trans,
          'grossesse': grossesse_trans,
          'langue': lang
        };

        logger.d(data['surdosage']);
        logger.d(option);
      }

      logger.d(data);
      return data;
      /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArView(
                  data: data,
                )),
      ); */

    }
  });
}

Future<String> goodValue(String medoc) async {
  String url = 'https://www.doctissimo.fr/medicament-$medoc.htm';
  final response = await http.get(Uri.parse(url));
  final body = response.body;
  final html = parse(body);
  final indication = html.querySelector("#collapseIndication")?.text.trim();
  if (indication != null) {
    return medoc;
  }

  return "null";
}
