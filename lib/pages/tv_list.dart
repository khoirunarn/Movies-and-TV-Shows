import 'package:flutter/material.dart';
import '../models/tv_show.dart';
import '../service/http_service.dart';
import 'tv_show_detail.dart';

class TvList extends StatefulWidget {
  final String timeWindow;

  TvList({required this.timeWindow});

  @override
  _TvListState createState() => _TvListState();
}

class _TvListState extends State<TvList> {
  late Future<List<TvShow>> trendingTvShows;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    trendingTvShows = httpService.getTrendingTvShows(widget.timeWindow); // Mendapatkan data TV shows
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending TV Shows'),
        backgroundColor: const Color.fromARGB(255, 234, 116, 255),
      ),
      body: FutureBuilder<List<TvShow>>(
        future: trendingTvShows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load TV shows'));
          } else if (snapshot.hasData) {
            final tvShows = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0), // Memberikan padding pada list
              itemCount: tvShows.length,
              itemBuilder: (context, index) {
                final tvShow = tvShows[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TvShowDetailScreen(seriesId: tvShow.id),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0), // Memberikan margin antar card
                    elevation: 4, // Memberikan shadow pada card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0), // Membuat sudut lebih halus
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Gambar Poster TV Show
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: tvShow.posterPath != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.tv, size: 50, color: Colors.grey),
                          ),
                          SizedBox(width: 16),
                          // Detail TV Show
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tvShow.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  tvShow.overview ?? 'No description available.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Button "Lihat" untuk menavigasi ke detail
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TvShowDetailScreen(seriesId: tvShow.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text('No TV shows available'));
        },
      ),
    );
  }
}
