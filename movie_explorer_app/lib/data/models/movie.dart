class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String plot;
  final String genre;
  final String director;
  final String actors;
  final String runtime;
  final String imdbRating;
  final String released;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
    required this.genre,
    required this.director,
    required this.actors,
    required this.runtime,
    required this.imdbRating,
    required this.released,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? json['title'] ?? 'No title', 
      year: json['Year'] ?? json['year'] ?? '',
      poster: (json['Poster'] == null || json['Poster'] == 'N/A') 
          ? 'https://via.placeholder.com/500' 
          : json['Poster'],
      plot: json['Plot'] ?? 'No description.', 
      genre: json['Genre'] ?? 'Unknown',
      director: json['Director'] ?? 'Unknown',
      actors: json['Actors'] ?? 'Unknown',
      runtime: json['Runtime'] ?? 'Unknown',
      imdbRating: json['imdbRating'] ?? 'Unknown',
      released: json['Released'] ?? 'Unknown',
    );
  }
}