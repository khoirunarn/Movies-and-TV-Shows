import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:praktikum8/models/tv_detail.dart';
import 'package:praktikum8/models/tv_show.dart';
import '../models/movie.dart';

class HttpService {
  final String apiKey = '77d504b2680435c7b0ced656956c819d';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3N2Q1MDRiMjY4MDQzNWM3YjBjZWQ2NTY5NTZjODE5ZCIsIm5iZiI6MTcyOTkyMjQzMC4wMjQ5OTk5LCJzdWIiOiI2NzFjODU3ZTVkMGRlODkwNDJkOTJiNzIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.-CY-RqD9vD37cTbUdMbMdQBI-4qMBebXGE0OxlkblWE';
  final String timeWindow = 'day';

  // film populer
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> results = body['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Mendapatkan TV shows yang trending
  Future<List<TvShow>> getTrendingTvShows(String timeWindow) async {
    final url = '$baseUrl/trending/tv/$timeWindow?language=en-US';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );

    // Debugging: Tampilkan status dan body respons
    print('Calling API: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final results = body['results'] as List;

      // Parsing hasil ke dalam List<TvShow>
      return results.map((json) => TvShow.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending TV shows');
    }
  }

  Future<TvShowDetail> getTvShowDetails(int seriesId) async {
    final url = '$baseUrl/tv/$seriesId?language=en-US';
    print('Calling API: $url');

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
      'accept': 'application/json',
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return TvShowDetail.fromJson(
          body); // Panggil fromJson dari model TvShowDetail
    } else {
      throw Exception('Failed to load TV show details');
    }
  }
}
