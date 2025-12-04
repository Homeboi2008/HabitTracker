import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteService _service = QuoteService();
  Quote? _quote;
  bool _isLoading = false;
  String? _error;

  Quote? get quote => _quote;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuote() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quote = await _service.getRandomQuote();
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _quote = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}

