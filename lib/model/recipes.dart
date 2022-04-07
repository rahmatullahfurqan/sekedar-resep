class Recipes {
  Recipes({
    required this.title,
    required this.thumb,
    required this.key,
    required this.times,
    required this.portion,
    required this.dificulty,
  });

  String title;
  String thumb;
  String key;
  String times;
  String portion;
  String dificulty;

  factory Recipes.fromJson(Map<String, dynamic> json) => Recipes(
        title: json["title"],
        thumb: json["thumb"],
        key: json["key"],
        times: json["times"],
        portion: json["portion"],
        dificulty: json["dificulty"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "thumb": thumb,
        "key": key,
        "times": times,
        "portion": portion,
        "dificulty": dificulty,
      };
}
