import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/MealApiService.dart';
import 'MealScreen.dart';
import 'MealDetailScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final MealApiService apiService = MealApiService();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final data = await apiService.getCategories();
    setState(() {
      categories = data;
      filteredCategories = data;
      isLoading = false;
    });
  }

  void filterCategories(String query) {
    final filtered = categories
        .where((cat) =>
        cat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredCategories = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории на јадења'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Рандом рецепт',
            onPressed: () async {
              final randomMeal = await apiService.getRandomMeal();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MealDetailScreen(mealId: randomMeal.id),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Пребарувај категории',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchCategories,
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.network(
                        category.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(category.name),
                      subtitle: Text(
                        category.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealScreen(category: category.name),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
