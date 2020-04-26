
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _API_KEY = 'c9607bc1f1834a67b93d547eb981edfb';
class NewsService with ChangeNotifier{


  List<Article> healines =[];

  String _selectedCategory = 'business';

  List<Category> categorias=[
    Category( FontAwesomeIcons.building, 'business'  ),
    Category( FontAwesomeIcons.tv, 'entertainment'  ),
    Category( FontAwesomeIcons.addressCard, 'general'  ),
    Category( FontAwesomeIcons.headSideVirus, 'health'  ),
    Category( FontAwesomeIcons.vials, 'science'  ),
    Category( FontAwesomeIcons.volleyballBall, 'sports'  ),
    Category( FontAwesomeIcons.memory, 'technology'  ),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService(){
    this.getTopHeadlines();
    categorias.forEach( (item) {
      this.categoryArticles[item.name] = new List();
    });
  }
  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor){
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoria=>this.categoryArticles[this.selectedCategory];

  getTopHeadlines () async{
    final url = '$_URL_NEWS/top-headlines?apiKey=$_API_KEY&country=mx';
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);

    this.healines.addAll(newsResponse.articles);
    notifyListeners();
  }
  getArticlesByCategory(String category)async{
    if (this.categoryArticles[category].length>0){
      return this.categoryArticles[category];
    }
    final url = '$_URL_NEWS/top-headlines?apiKey=$_API_KEY&country=mx&category=$_selectedCategory';
    final resp = await http.get(url);
    final newResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newResponse.articles);

    notifyListeners();
  }
}