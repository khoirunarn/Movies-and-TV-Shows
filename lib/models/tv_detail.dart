class TvShowDetail {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? firstAirDate;
  final List<String> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  TvShowDetail({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    this.firstAirDate,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory TvShowDetail.fromJson(Map<String, dynamic> json) {
    return TvShowDetail(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      firstAirDate: json['first_air_date'],
      genres: (json['genres'] as List<dynamic>)
          .map((genre) => genre['name'] as String)
          .toList(),
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
    );
  }
}
