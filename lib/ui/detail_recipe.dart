import 'package:flutter/material.dart';
import 'package:submission_dicoding_flutter2/model/recipe_detail.dart';
import 'package:submission_dicoding_flutter2/model/recipes.dart';
import 'package:submission_dicoding_flutter2/service/apiservices.dart';

class DetailRecipe extends StatelessWidget {
  final Recipes recipes;
  DetailRecipe({required this.recipes});
  List<Widget> widgetlistIngredient = [];
  List<String> ingredientList = [];
  List<Widget> widgetlistStep = [];
  List<String> stepList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                Image.network(
                  recipes.thumb,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.70,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, left: 16, right: 8),
              child: Text(
                recipes.title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Oxygen',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: FutureBuilder<RecipeDetail>(
                future: ApiServices.getRecipeDetail(recipes.key),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: MediaQuery.of(context).size.width,
                        child: showLoadingProgres());
                  } else {
                    RecipeDetail recipeDetail = snapshot.data!;
                    ingredientList = recipeDetail.ingredient;
                    stepList = recipeDetail.step;
                    getWidgetsIngredient();
                    getWidgetsStep();
                    return Column(
                      children: [
                        author(recipeDetail.author.user,
                            recipeDetail.author.datePublished),
                        const SizedBox(
                          height: 20,
                        ),
                        status(recipeDetail),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Oxygen',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        deskripsiResep(recipeDetail.desc),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Bahan',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Oxygen',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        bahanResep(),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Langkah-Langkah',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Oxygen',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        stepResep(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deskripsiResep(String deskripsi) => Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 5.0),
            ]),
        child: Expanded(
          child: Text(deskripsi),
        ),
      );

  Widget stepResep() => Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 5.0),
            ]),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: widgetlistStep.map((element) {
            return element;
          }).toList(),
        ),
      );

  Widget bahanResep() => Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 5.0),
            ]),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: widgetlistIngredient.map((element) {
            return element;
          }).toList(),
        ),
      );

  void getWidgetsIngredient() {
    for (int i = 0; i < ingredientList.length - 1; i += 2) {
      widgetlistIngredient.add(Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '- ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      ingredientList[i].toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '- ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      ingredientList[i + 1].toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    }
  }

  void getWidgetsStep() {
    for (int i = 0; i < stepList.length; i++) {
      widgetlistStep.add(Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '- ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                stepList[i].toString().split(' ').skip(1).join(' '),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ));
    }
  }

  Widget status(RecipeDetail detailRecipe) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 5.0),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.youtube_searched_for,
                    color: Color.fromARGB(255, 231, 136, 55),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    detailRecipe.dificulty,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 5.0),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timelapse,
                    color: Color.fromARGB(255, 207, 13, 78),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    detailRecipe.times,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 5.0),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fastfood,
                    color: Color.fromARGB(255, 231, 136, 55),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    detailRecipe.servings,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget author(String authorName, String publishedDate) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'by $authorName',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              publishedDate,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  Widget showLoadingProgres() => const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 231, 136, 55),
          ),
        ),
      );
}
