import 'package:translator/translator.dart';

class TranslationHelper {
  final GoogleTranslator translator;

  TranslationHelper({GoogleTranslator? translator})
    : translator = translator ?? GoogleTranslator();

  Future<String> translateText(String text, {String to = 'id'}) async {
    if (text.isEmpty) return text;
    try {
      final translation = await translator.translate(text, to: to);
      return translation.text;
    } catch (e) {
      return text;
    }
  }

  Future<List<String>> translateList(
    List<String> texts, {
    String to = 'id',
  }) async {
    if (texts.isEmpty) return texts;
    try {
      final results = await Future.wait(
        texts.map((text) => translateText(text, to: to)),
      );
      return results;
    } catch (e) {
      return texts;
    }
  }
}
