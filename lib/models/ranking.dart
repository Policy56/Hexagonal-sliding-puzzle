/// Item to read Firebase Database
class RankingItem {
  ///Ctor
  RankingItem(
    this.user,
    this.nbTilesMoved,
    this.nbSeconds,
    this.score,
    this.difficulty,
    this.date,
  );

  ///Reader from Json
  RankingItem.fromJson(Map<dynamic, dynamic> json)
      : user = json['user'] as String,
        nbTilesMoved = json['nbTilesMoved'] as int,
        nbSeconds = json['nbSeconds'] as int,
        difficulty = json['difficulty'] as String,
        score = json['score'] as int,
        date = DateTime.parse(json['date'] as String);

  ///Data to Json
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'user': user,
        'nbTilesMoved': nbTilesMoved,
        'nbSeconds': nbSeconds,
        'difficulty': difficulty,
        'score': score,
        'date': date.toString(),
      };

  /// Utilisateur
  final String user;

  /// nb of Moved TIles
  final int nbTilesMoved;

  /// Nb of seconds
  final int nbSeconds;

  /// nb of Date
  final DateTime date;

  /// Score of the game
  final int score;

  /// nb of Date
  final String difficulty;
}
