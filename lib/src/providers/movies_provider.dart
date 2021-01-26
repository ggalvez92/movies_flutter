import 'package:http/http.dart' as http;
import 'package:movies/src/models/actor_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apikey = '435a1cd5959cba90eb3542ea49a62c1a';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  List<Movie> _populars = new List();
  bool _loadingData = false;
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;
  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _procesarRespuesta(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Movie>> getPopulares() async {
    _popularesPage++;

    if (_loadingData) return [];
    _loadingData = true;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final response = await _procesarRespuesta(url);
    _populars.addAll(response);
    popularsSink(_populars);

    _loadingData = false;
    return response;
  }

  Future<List<Actor>> getActors(movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final response = await http.get(url);
    final decodeData = json.decode(response.body);
    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {'api_key': _apikey, 'language': _language, 'query': query},
    );
    return await _procesarRespuesta(url);
  }
}
