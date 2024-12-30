class Joke {
  final String category;
  final String type;
  final String joke;

  Joke({
    required this.category,
    required this.type,
    required this.joke,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      category: json['category'] as String,
      type: json['type'] as String,
      joke: json['joke'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'type': type,
      'joke': joke,
    };
  }
}
