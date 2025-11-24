class MealDetail {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final List<String> ingredients;
  final String youtube;

  MealDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    required this.youtube,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredientsList.add('$ingredient - ${measure ?? ''}');
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredientsList,
      youtube: json['strYoutube'] ?? '',
    );
  }
}
