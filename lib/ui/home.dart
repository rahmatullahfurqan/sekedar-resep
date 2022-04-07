import 'package:flutter/material.dart';
import 'package:submission_dicoding_flutter2/model/recipes.dart';
import 'package:submission_dicoding_flutter2/service/apiservices.dart';
import 'package:submission_dicoding_flutter2/ui/detail_recipe.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();
  TextEditingController textController = TextEditingController();
  bool showProgresBar = false;
  bool isLoadingFirst = true;
  bool searchLoading = false;
  bool bantu = true;
  bool isOnSearching = false;
  bool refreshTop = false;
  late FocusNode myFocusNode;
  String titleRecipe = 'Resep untukmu hari ini';
  double topContainer = 0;
  List<Recipes> itemRecipes = [];

  @override
  void dispose() {
    textController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    getData();
    controller.addListener(() {
      double value = controller.offset / 378;
      //print(controller.offset);
      if (value > 8 && itemRecipes.length < 11 && bantu) {
        bantu = false;
        showProgresBar = true;
        getData2();
      }
      if (value < -0.3 && !refreshTop) {
        refreshTop = true;
        getData();
      }
      setState(() {
        topContainer = value;
      });
    });
  }

  void getData() async {
    titleRecipe = 'Resep untukmu hari ini';
    List<Recipes> recipe = await ApiServices.getRecipes();
    setState(() {
      //itemArticle = article;
      itemRecipes = recipe;
      isLoadingFirst = false;
      searchLoading = false;
      refreshTop = false;
    });
  }

  void getData2() async {
    List<Recipes> recipe2 = await ApiServices.getRecipes();
    setState(() {
      itemRecipes.addAll(recipe2);
      showProgresBar = false;
      bantu = true;
    });
  }

  void search(String value) async {
    setState(() {
      isOnSearching = true;
      titleRecipe = "Hasil Pencarian Resep '$value'";
    });
    List<Recipes> searchRecipe = await ApiServices.searchRecipe(value);
    setState(() {
      itemRecipes = searchRecipe;
      searchLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          title: logoAppBar(),
        ),
        body: isLoadingFirst
            ? showLoadingProgres()
            : Container(
                color: Colors.white,
                height: size.height,
                width: size.width,
                child: Column(
                  children: <Widget>[
                    searchBar(),
                    const SizedBox(
                      height: 10,
                    ),
                    titleBar(),
                    const SizedBox(
                      height: 10,
                    ),
                    refreshTop ? showLoadingProgres() : Container(),
                    searchLoading
                        ? Expanded(
                            child: showLoadingProgres(),
                          )
                        : RecipesWidget(),
                    showProgresBar ? showLoadingProgres() : Container(),
                  ],
                ),
              ));
  }

  Widget showLoadingProgres() => const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 231, 136, 55),
          ),
        ),
      );

  Widget searchBar() => Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 4.0),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isOnSearching
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (textController.value.text == '') {
                        isOnSearching = false;
                        myFocusNode.unfocus();
                      } else {
                        setState(() {
                          isOnSearching = false;
                          searchLoading = true;
                          textController.clear();
                          myFocusNode.unfocus();
                          getData();
                        });
                      }
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      isOnSearching = true;
                      myFocusNode.requestFocus();
                    },
                  ),
            Expanded(
              child: TextField(
                focusNode: myFocusNode,
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mau masak apa hari ini?',
                ),
                textAlignVertical: TextAlignVertical.center,
                onTap: () => isOnSearching = true,
                onSubmitted: (value) {
                  if (value == '') {
                    setState(() {
                      isOnSearching = false;
                      searchLoading = true;
                      textController.clear();
                    });
                    getData();
                  } else {
                    searchLoading = true;
                    search(value);
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget titleBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: isOnSearching
            ? Text(
                titleRecipe,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Oxygen',
                ),
              )
            : Text(
                titleRecipe,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Staatliches',
                ),
              ),
      );

  Widget logoAppBar() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                "images/logo.png",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Sekedar ',
              style: TextStyle(
                  color: Color.fromARGB(255, 207, 13, 78),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oxygen'),
            ),
            const Text(
              'Resep',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 136, 55),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oxygen'),
            ),
          ],
        ),
      );

  Widget RecipesWidget() => Expanded(
      child: ListView.builder(
          controller: controller,
          itemCount: itemRecipes.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            double scale = 1.0;
            if (topContainer > 0) {
              scale = index + 1 - topContainer;
              if (scale < 0) {
                scale = 0;
              } else if (scale > 1) {
                scale = 1;
              }
            }
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return DetailRecipe(
                      recipes: itemRecipes[index],
                    );
                  }),
                );
              },
              child: Opacity(
                opacity: scale,
                child: Transform(
                  transform: Matrix4.identity()..scale(scale, scale),
                  alignment: Alignment.bottomCenter,
                  child: Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topCenter,
                      child: RecipeCard(itemRecipes[index])),
                ),
              ),
            );
          }));

  Widget RecipeCard(Recipes recipe) => Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  recipe.thumb,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingprogress) {
                    if (loadingprogress == null) {
                      return child;
                    }
                    return Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          "images/loading2.jpg",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 20, left: 20, right: 20),
                    child: Text(
                      recipe.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oxygen',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.youtube_searched_for,
                                color: Color.fromARGB(255, 231, 136, 55),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                recipe.dificulty,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 13, 78),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.timelapse,
                                color: Color.fromARGB(255, 207, 13, 78),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                recipe.times,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 231, 136, 55),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.fastfood,
                                color: Color.fromARGB(255, 231, 136, 55),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                recipe.portion,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 13, 78),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ));
}
