import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String _baseUrl = 'https://api.adviceslip.com/advice';

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final slip = jsonData['slip'] as Map<String, dynamic>;
        final advice = slip['advice'] as String;
        
        return Quote(
          content: advice,
          author: 'Совет',
        );
      } else {
        throw Exception('Не удалось загрузить цитату: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException') || 
          e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        return _getFallbackQuote();
      }
      throw Exception('Ошибка при загрузке цитаты: $e');
    }
  }

  Quote _getFallbackQuote() {
    final fallbackQuotes = [
      Quote(content: 'Путь в тысячу миль начинается с одного шага', author: 'Лао-Цзы'),
      Quote(content: 'Успех - это способность идти от неудачи к неудаче, не теряя энтузиазма', author: 'Уинстон Черчилль'),
      Quote(content: 'Единственный способ делать великую работу - это любить то, что ты делаешь', author: 'Стив Джобс'),
      Quote(content: 'Не откладывай на завтра то, что можешь сделать сегодня', author: 'Бенджамин Франклин'),
      Quote(content: 'Мотивация заставляет вас начать. Привычка заставляет продолжать', author: 'Джим Рон'),
    ];
    return fallbackQuotes[DateTime.now().millisecond % fallbackQuotes.length];
  }
}
