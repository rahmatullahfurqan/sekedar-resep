import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:submission_dicoding_flutter2/model/recipe_detail.dart';
import 'package:submission_dicoding_flutter2/model/recipes.dart';

class ApiServices {
  static String urlImage = '';
  static const host = 'https://masak-apa-tomorisakura.vercel.app';

  static Future<List<Recipes>> getRecipes() async {
    List<Recipes> listRecipes = [];
    try {
      final response = await http.get(Uri.parse('$host/api/recipes'));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var parsed = json['results'].cast<Map<String, dynamic>>();
        for (var i in parsed) {
          Recipes recipe = Recipes(
              title: i['title'],
              thumb: i['thumb'],
              key: i['key'],
              times: i['times'],
              portion: i['portion'],
              dificulty: i['dificulty']);
          listRecipes.add(recipe);
        }
        return listRecipes;
      } else {
        print('asu');
        return [];
      }
    } catch (e) {
      print('bangsad');
      return [];
    }
  }

  static Future<List<Recipes>> searchRecipe(String value) async {
    List<Recipes> listRecipes = [];
    try {
      final response = await http.get(Uri.parse('$host/api/search/?q=$value'));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var parsed = json['results'].cast<Map<String, dynamic>>();
        for (var i in parsed) {
          Recipes recipe = Recipes(
              title: i['title'],
              thumb: i['thumb'],
              key: i['key'],
              times: i['times'],
              portion: i['serving'],
              dificulty: i['difficulty']);
          listRecipes.add(recipe);
        }
        return listRecipes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Recipes>> getRecipes2() async {
    List<Recipes> listRecipes = [];
    try {
      final response = await http.get(Uri.parse('$host/api/recipes/2'));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var parsed = json['results'].cast<Map<String, dynamic>>();
        for (var i in parsed) {
          Recipes recipe = Recipes(
              title: i['title'],
              thumb: i['thumb'],
              key: i['key'],
              times: i['times'],
              portion: i['portion'],
              dificulty: i['dificulty']);
          listRecipes.add(recipe);
        }
        return listRecipes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<RecipeDetail> getRecipeDetail(String key) async {
    try {
      final response = await http.get(Uri.parse('$host/api/recipe/$key'));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var parsed = (json['results']);
        List<NeedItem> needItem = [];
        List<String> step = [];
        List<String> ingredient = [];
        for (var i in parsed['needItem']) {
          needItem.add(
              NeedItem(itemName: i['item_name'], thumbItem: i['thumb_item']));
        }
        for (var i in parsed['step']) {
          step.add(i);
        }
        for (var i in parsed['ingredient']) {
          ingredient.add(i);
        }
        RecipeDetail recipeDetail = RecipeDetail(
            title: parsed['title'],
            thumb: parsed['thumb'] ??
                'https://www.masakapahariini.com/wp-content/uploads/2019/03/ikan-siram-kecombrang-620x440.jpg',
            servings: parsed['servings'],
            times: parsed['times'],
            dificulty: parsed['dificulty'],
            author: new Author(
                user: parsed['author']['user'],
                datePublished: parsed['author']['datePublished']),
            desc: parsed['desc'],
            needItem: needItem,
            ingredient: ingredient,
            step: step);
        return recipeDetail;
      } else {
        return RecipeDetail(
          title: 'title',
          thumb: 'thumb',
          servings: 'servings',
          times: 'times',
          dificulty: 'dificulty',
          author: new Author(user: 'user', datePublished: 'datePublished'),
          desc: 'desc',
          needItem: [
            new NeedItem(itemName: 'itemName', thumbItem: 'thumbItem')
          ],
          ingredient: ['ingredient'],
          step: ['step'],
        );
      }
    } catch (e) {
      return RecipeDetail(
        title: 'title',
        thumb: 'thumb',
        servings: 'servings',
        times: 'times',
        dificulty: 'dificulty',
        author: new Author(user: 'user', datePublished: 'datePublished'),
        desc: 'desc',
        needItem: [new NeedItem(itemName: 'itemName', thumbItem: 'thumbItem')],
        ingredient: ['ingredient'],
        step: ['step'],
      );
    }
  }
}
