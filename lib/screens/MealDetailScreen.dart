import 'package:flutter/material.dart';
import '../models/mealDetail.dart';
import '../services/MealApiService.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService apiService = MealApiService();
  MealDetail? mealDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  void fetchMealDetail() async {
    final data = await apiService.getMealDetail(widget.mealId);
    setState(() {
      mealDetail = data;
      isLoading = false;
    });
  }

  void openYoutube(String url) async {
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetail?.name ?? 'Детален рецепт'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(mealDetail!.image),
            const SizedBox(height: 10),
            Text(
              mealDetail!.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Состојки:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...mealDetail!.ingredients
                .map((ing) => Text(ing))
                .toList(),
            const SizedBox(height: 10),
            const Text(
              'Инструкции:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(mealDetail!.instructions),
            const SizedBox(height: 10),
            if (mealDetail!.youtube.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => openYoutube(mealDetail!.youtube),
                icon: const Icon(Icons.video_library),
                label: const Text('Гледај на YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
