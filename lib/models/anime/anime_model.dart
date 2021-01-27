class AnimeModel {
  String animeId;
  String animeName;
  double animeRate;
  int animeViews;
  String animeImage;
  double animeDuration;
  String animeGenre;
  String publishedDate;

  AnimeModel({this.animeId , this.animeName , this.animeGenre , this.animeDuration , this.animeImage , this.animeRate , this.animeViews , this.publishedDate});

  factory AnimeModel.fromJson(Map<String , dynamic> json , id){
  return AnimeModel(
    animeId: id,
            animeGenre: json['anime_genre'],
            animeName: json['anime_name'],
            animeDuration: json['anime_duration'],
            animeImage: json['anime_image'],
            animeRate: json['anime_rate'],
            animeViews: json['anime_views'],
            publishedDate: json['publishedDate'],
  );
}
}

