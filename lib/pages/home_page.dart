import 'package:flutter/material.dart';
import 'package:praktikum8/models/tv_show.dart';
import 'package:praktikum8/pages/tv_list.dart';
import '../service/http_service.dart';
import '../models/movie.dart';
import 'movie_populer.dart';
import 'tv_show_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpService httpService = HttpService();
  late Future<List<Movie>> popularMovies;

  @override
  void initState() {
    super.initState();
    popularMovies =
        httpService.getPopularMovies(); // Mendapatkan data film populer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 240, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Full Screen
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25, // Header 30% layar
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 60.0), // Menambahkan padding untuk menghindari terhalang oleh bagian atas layar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Mau lihat apa hari ini?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            child: Image.network(
                              'https://cdn3.iconfinder.com/data/icons/business-avatar-1/512/11_avatar-512.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari film',
                        prefixIcon: Icon(Icons.search, color: Colors.purple),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Navigasi ke MoviePopuler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoviePopuler()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Film Populer',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.purple),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildMovieList(popularMovies),
            SizedBox(height: 20),
            // Navigasi ke TvList
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TvList(timeWindow: 'day')),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TV Shows Trending',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.purple),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTrendingTvShows(), // Widget untuk TV shows trending
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(Future<List<Movie>> moviesFuture) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load movies'));
        } else if (snapshot.hasData) {
          final movies = snapshot.data!;
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 120,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          height: 140,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildTrendingTvShows() {
    return FutureBuilder<List<TvShow>>(
      future: httpService.getTrendingTvShows("day"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load TV shows'));
        } else if (snapshot.hasData) {
          final tvShows = snapshot.data!;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true, 
              itemCount: tvShows.length,
              itemBuilder: (context, index) {
                final tvShow = tvShows[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: tvShow.posterPath != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                                    height: 120,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.tv, size: 50),
                          ),
                          SizedBox(width: 10), 
                          Expanded(
                            child: Text(
                              tvShow.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TvShowDetailScreen(seriesId: tvShow.id),
                                ),
                              );
                            },
                            child: Text('Lihat'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
