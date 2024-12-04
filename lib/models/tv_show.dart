class TvShow {
  final int id;
  final String name;
  final String? posterPath;
  final String? overview;  // Pastikan overview bisa null

  TvShow({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  // Membuat TvShow dari JSON
  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      name: json['name'],
      posterPath: json['poster_path'],  // Bisa null
      overview: json['overview'],  // Bisa null
    );
  }
}
