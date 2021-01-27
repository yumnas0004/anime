import 'package:anime/models/anime/anime_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin AnimeController on Model {
  String _url = 'https://anime-99bdd-default-rtdb.firebaseio.com/animes.json';
  bool _isGetAnimeLoading;
  bool get isGetAnimeLoading => _isGetAnimeLoading;
  bool _isAddAnimeLoading;
  bool get isAddAnimeLoading => _isAddAnimeLoading;
  bool _isDeleteAnimeLoading;
  bool get isDeleteAnimeLoding => _isDeleteAnimeLoading;
  bool _isUpdateAnimeLoading;
  bool get isUpdateAnimeLoading => _isUpdateAnimeLoading;
  List<AnimeModel> _animeList = [];
  List<AnimeModel> get animeList => _animeList;
  String _selectedAnimeId;
  AnimeModel get selectedAnime => _animeList.firstWhere(
      (AnimeModel animeModel) => animeModel.animeId == _selectedAnimeId);
  List<AnimeModel> _favoriteList = [];
  List<AnimeModel> get favoriteList => _favoriteList;

  selectMovie(String id) {
    return _selectedAnimeId = id;
  }

  Future<bool> updateAnime(
      {String id, String animeName, double animeDuration}) async {
    _isUpdateAnimeLoading = true;
    notifyListeners();

    Map<String, dynamic> _data = {
      'anime_name': animeName,
      'anime_duration': animeDuration,
      'anime_rate': 7.5,
      'anime_views': 200,
      'publishedDate': DateTime.now().toString().substring(0, 10),
      'anime_image':
          'https://firebasestorage.googleapis.com/v0/b/anime-99bdd.appspot.com/o/images%2Fonepiece.jpg?alt=media&token=3da6b10a-525b-4669-bb9a-1ed675b31bab'
    };
    try {
      http.Response _response = await http.put(
          'https://anime-99bdd-default-rtdb.firebaseio.com/animes/$id.json',
          body: json.encode(_data));
      if (_response.statusCode == 200) {
        _isUpdateAnimeLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isUpdateAnimeLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getAnime() async {
    _isGetAnimeLoading = true;
    notifyListeners();

    try {
      http.Response _response = await http.get(_url);
      var _data = json.decode(_response.body);
      if (_response.statusCode == 200) {
        _data.forEach((id, e) {
          final AnimeModel _newAnime = AnimeModel.fromJson(e, id);
          _animeList.add(_newAnime);
        });
        _isGetAnimeLoading = false;
        notifyListeners();
        return true;
      } else {
        _isGetAnimeLoading = false;
        notifyListeners();
        return false;
      }

      // Firestore.instance.collection('anime').getDocuments().then((snapshot) {
      //   snapshot.documents.forEach((e) {
      //     final AnimeModel _newAnime = AnimeModel.fromJson(e);
      //     _animeList.add(_newAnime);
      //   });
      //   _isGetAnimeLoading = false;
      //   notifyListeners();
      //   return true;
      // });
    } catch (e) {
      _isGetAnimeLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAnime(String id) async {
    _isDeleteAnimeLoading = true;
    notifyListeners();
    http.Response _response = await http.delete(
        'https://anime-99bdd-default-rtdb.firebaseio.com/animes/$id.json');
    if (_response.statusCode == 200) {
      _animeList
          .removeWhere((AnimeModel animeModel) => animeModel.animeId == id);
      _isDeleteAnimeLoading = false;
      notifyListeners();
      return true;
    } else {
      _isDeleteAnimeLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addAnime(String animeName, double animeDuration) async {
    _isAddAnimeLoading = true;
    notifyListeners();

    Map<String, dynamic> _data = {
      'anime_name': animeName,
      'anime_duration': animeDuration,
      'anime_rate': 7.5,
      'anime_views': 200,
      'publishedDate': DateTime.now().toString().substring(0, 10),
      'anime_image':
          'https://firebasestorage.googleapis.com/v0/b/anime-99bdd.appspot.com/o/images%2Fonepiece.jpg?alt=media&token=3da6b10a-525b-4669-bb9a-1ed675b31bab'
    };

    try {
      // Firestore.instance.collection('anime').add(_data);

      http.Response _response = await http.post(_url, body: json.encode(_data));
      if (_response.statusCode == 200) {
        _isAddAnimeLoading = false;
        notifyListeners();
        return true;
      } else {
        _isAddAnimeLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isAddAnimeLoading = false;
      notifyListeners();
      return false;
    }
  }

  addToFavorite(String id) {
    AnimeModel _animeModel = _animeList
        .firstWhere((AnimeModel animeModel) => animeModel.animeId == id);
    _favoriteList.add(_animeModel);
    
  }
}
