import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/mealDetail.dart';

class MealApiService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${baseUrl}categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List categoriesJson = data['categories'];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('${baseUrl}filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List mealsJson = data['meals'];
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    }
    return [];
  }

  Future<MealDetail> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    }
    throw Exception('Failed to load meal detail');
  }

  Future<Meal> getRandomMeal() async {
    final response = await http.get(Uri.parse('${baseUrl}random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    }
    throw Exception('Failed to load random meal');
  }
}
