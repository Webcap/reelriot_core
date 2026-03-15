/// Genre from TMDB genre list.
class Genre {
  final int id;
  final String? name;

  Genre({required this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String?,
    );
  }
}
