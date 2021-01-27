import 'package:anime/models/anime/anime_controller.dart';
import 'package:anime/models/category/category_controller.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with AnimeController , CategoryController{}