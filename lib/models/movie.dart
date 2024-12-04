class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage; // Tambahkan voteAverage
  final String releaseDate; // Tambahkan releaseDate

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage, // Tambahkan ke constructor
    required this.releaseDate, // Tambahkan ke constructor
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0, // Default 0.0 jika null
      releaseDate: json['release_date'] ?? 'Unknown', // Default 'Unknown' jika null
    );
  }
}
