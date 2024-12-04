import 'package:flutter/material.dart';
import 'package:praktikum8/models/tv_detail.dart'; // Pastikan impor model yang benar
import '../service/http_service.dart'; // Pastikan mengimpor HttpService yang benar

class TvShowDetailScreen extends StatefulWidget {
  final int seriesId;

  TvShowDetailScreen({required this.seriesId});

  @override
  _TvShowDetailScreenState createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  late Future<TvShowDetail> tvShowDetail;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    tvShowDetail = httpService.getTvShowDetails(widget.seriesId); // Mendapatkan detail TV show berdasarkan seriesId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TvShowDetail>(
        future: tvShowDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Menunggu data
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load TV show details')); // Menampilkan error jika ada
          } else if (snapshot.hasData) {
            final tvShow = snapshot.data!; // Mengambil data TV show
            return Column(
              children: [
                // Bagian gambar full screen
                Stack(
                  children: [
                    tvShow.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.6,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Icon(Icons.tv, size: 100, color: Colors.grey),
                          ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bagian informasi detail di bawah gambar
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama TV Show
                        Text(
                          tvShow.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Genre
                        Text(
                          tvShow.genres.isNotEmpty
                              ? tvShow.genres.join(', ')
                              : 'No genres available',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),

                        // Tanggal Tayang Pertama
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black54, size: 20),
                            SizedBox(width: 5),
                            Text(
                              'First Air Date: ${tvShow.firstAirDate ?? 'Unknown'}',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Jumlah Episode dan Season
                        Row(
                          children: [
                            Icon(Icons.play_circle_fill, color: Colors.black54, size: 20),
                            SizedBox(width: 5),
                            Text(
                              'Episodes: ${tvShow.numberOfEpisodes ?? 0}, Seasons: ${tvShow.numberOfSeasons ?? 0}',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Deskripsi
                        Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          tvShow.overview?.isNotEmpty == true
                              ? tvShow.overview!
                              : 'No description available.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox(); // Menampilkan widget kosong jika tidak ada data
        },
      ),
    );
  }
}
