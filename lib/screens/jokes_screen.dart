import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/jokes_service.dart';
import '../models/joke.dart';

class JokesScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const JokesScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  final JokesService jokesService = JokesService();
  List<Joke> jokes = [];
  bool isLoading = false;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // Check connectivity status
  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult == ConnectivityResult.none;
    });
    if (!isOffline) {
      fetchJokes();
    } else {
      // If offline, try to load jokes from cache
      loadJokesFromCache();
    }
  }

  // Fetch jokes method
  Future<void> fetchJokes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedJokes = await jokesService.fetchJokes();
      setState(() {
        jokes = fetchedJokes;
      });
      await jokesService.saveJokesToCache(fetchedJokes); // Save to cache
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch jokes from API.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load jokes from cache
  Future<void> loadJokesFromCache() async {
    final cachedJokes = await jokesService.loadJokesFromCache();
    setState(() {
      jokes = cachedJokes;
    });
    if (cachedJokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No jokes available in cache.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JokeZone', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome to the Jokes App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Looking for a good laugh? Press the button below to load some hilarious jokes!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : fetchJokes,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Text(
              'Load Jokes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: jokes.isEmpty
                ? isOffline
                ? const Center(
              child: Text(
                'You are offline! Displaying cached jokes...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : const Center(
              child: Text(
                'No jokes available! Click "Load Jokes" to fetch some.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: widget.isDarkMode
                      ? Colors.grey[900]
                      : Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          joke.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          joke.joke,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
