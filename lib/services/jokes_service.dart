import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/joke.dart';

class JokesService {
  final String apiUrl = 'https://v2.jokeapi.dev/joke/Any?type=single&amount=5';

  // Fetch jokes from API
  Future<List<Joke>> fetchJokes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jokesList = data['jokes'] as List<dynamic>;
        return jokesList.map((joke) => Joke.fromJson(joke)).toList();
      } else {
        throw Exception('API responded with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching jokes: $error');
      throw Exception('Failed to fetch jokes');
    }
  }

  // Save jokes to SharedPreferences
  Future<void> saveJokesToCache(List<Joke> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = jokes.map((joke) => joke.toJson()).toList();
    prefs.setString('cached_jokes', jsonEncode(jokesJson));
  }

  // Load jokes from SharedPreferences
  Future<List<Joke>> loadJokesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJokes = prefs.getString('cached_jokes');
    if (cachedJokes != null) {
      final jokesList = jsonDecode(cachedJokes) as List<dynamic>;
      return jokesList.map((joke) => Joke.fromJson(joke)).toList();
    } else {
      return []; // Return an empty list if no jokes are cached
    }
  }
}
