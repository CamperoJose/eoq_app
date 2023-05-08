import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getGPTAdvice(List<double?> eoqData) async {
  OpenAI.apiKey = 'API-KEY';

  final prompt = 'EOQ básico: ${eoqData[0]}, EOQ faltantes: ${eoqData[1]}, EOQ descuentos: ${eoqData[2]}. ¿En base a estos datos, qué EOQ me recomiendas? Por favor, elige solo una opción y presenta tu respuesta en una estructura clara y concisa.';

  final completion = await OpenAI.instance.completion.create(
    model: "text-davinci-003",
    prompt: prompt,
    maxTokens: 100,
    n: 1,
    stop: null,
    temperature: 1,
  );

  final advice = completion.choices[0].text;
  return advice.trim();
}
