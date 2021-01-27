import 'package:anime/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

mixin CategoryController on Model {
  bool _isGetCategoriesLoading = true;
  bool get isGetCategoriesLoading => _isGetCategoriesLoading;
  List<CategoryModel> _allCategories = [];
  List<CategoryModel> get allCategories => _allCategories;

  Future<bool> getCategories() async {
    _isGetCategoriesLoading = true;
    notifyListeners();
    try {
      Firestore.instance
          .collection('categories')
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((e) {
          final CategoryModel _categories = CategoryModel(
              categoryId: e.documentID, categoryName: e['category_name']);
          _allCategories.add(_categories);
        });
        print(_allCategories);
        _isGetCategoriesLoading = false;
        notifyListeners();
        return true;
      });
    } catch (e) {
      _isGetCategoriesLoading = false;
      notifyListeners();
      return false;
    }
  }
}
