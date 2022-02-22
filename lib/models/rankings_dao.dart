import 'package:firebase_database/firebase_database.dart';
import 'package:hexagonal_sliding_puzzle/models/ranking.dart';

/// Dao of itemRanking
class RankingsDAO {
  final DatabaseReference _rankingsRef =
      FirebaseDatabase.instance.ref().child('ranking');

  ///Save rankToBD
  Future<void> saveMyRank(
    String user,
    String difficulty,
    int nbTilesMoved,
    int secondsElapsed,
    int baseScore,
  ) async {
    var playingScore = baseScore - nbTilesMoved - secondsElapsed;
    playingScore = (playingScore > 0) ? playingScore : 0;

    final rankingItem = RankingItem(
      user,
      nbTilesMoved,
      secondsElapsed,
      playingScore,
      difficulty,
      DateTime.now(),
    );

    //final once = await _rankingsRef.once();

    await _rankingsRef.child(difficulty).push().set(rankingItem.toJson());
  }

  ///Return ref or Ranking
  DatabaseReference getRefOfInstance() {
    return _rankingsRef;
  }

  ///return stream onvalue of Ranking ref
  Stream<DatabaseEvent> getRankingsOnValue() {
    return _rankingsRef.onValue;
  }
}
