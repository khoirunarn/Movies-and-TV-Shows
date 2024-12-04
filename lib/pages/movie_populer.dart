import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../service/http_service.dart';
import 'movie_detail.dart';

class MoviePopuler extends StatefulWidget {
  @override
  _MoviePopulerState createState() => _MoviePopulerState();
}

class _MoviePopulerState extends State<MoviePopuler> {
  final HttpService httpService = HttpService();
  late Future<List<Movie>> popularMovies;

  // List untuk menyimpan film favorit
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    popularMovies = httpService.getPopularMovies(); // Mendapatkan data film populer
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Hanya satu tab untuk film populer
      child: Scaffold(
        appBar: AppBar(
          title: Text('Film Populer'),
        backgroundColor: const Color.fromARGB(255, 234, 116, 255),
        ),
        body: TabBarView(
          children: [
            _buildMovieList(),  // Menampilkan daftar film populer
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan daftar film populer
  Widget _buildMovieList() {
    return FutureBuilder<List<Movie>>(
      future: popularMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Menunggu data
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load movies')); // Error loading
        } else if (snapshot.hasData) {
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final isFavorite = favoriteMovies.contains(movie); // Cek apakah film ini favorit
              return Card(
                child: ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}', // Gambar poster
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          favoriteMovies.remove(movie); // Hapus dari favorit
                        } else {
                          favoriteMovies.add(movie); // Tambahkan ke favorit
                        }
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(movie: movie),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
