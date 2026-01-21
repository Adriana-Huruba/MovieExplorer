class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String plot;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? 'No title',
      year: json['Year'] ?? '',
      poster: (json['Poster'] == null || json['Poster'] == 'N/A') 
          ? 'https://via.placeholder.com/500' 
          : json['Poster'],
      plot: json['Plot'] ?? 'No description.',
    );
  }
}