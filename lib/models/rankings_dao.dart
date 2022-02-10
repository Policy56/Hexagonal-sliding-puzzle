import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'ranking.dart';

/// Dao of itemRanking
class RankingsDAO {
  final DatabaseReference _rankingsRef =
      FirebaseDatabase.instance.ref().child('ranking');

  ///Save rankToBD
  void saveMyRank(
    String user,
    String difficulty,
    int nbTilesMoved,
    int secondsElapsed,
    int baseScore,
  ) async {
    var playingScore = baseScore - nbTilesMoved - secondsElapsed;
    playingScore = (playingScore > 0) ? playingScore : 0;

    final rankingItem = RankingItem(user, nbTilesMoved, secondsElapsed,
        playingScore, difficulty, DateTime.now());

    //final once = await _rankingsRef.once();

    await _rankingsRef.child(difficulty).push().set(rankingItem.toJson());
  }

  Query getRankingsQuery() {
    return _rankingsRef;
  }

  DatabaseReference getRefOfInstance() {
    return _rankingsRef;
  }

  Stream<DatabaseEvent> getRankingsOnValue() {
    return _rankingsRef.onValue;
  }

  /*  // Get the Stream
Stream<DatabaseEvent> stream = _rankingsRef.onValue;

// Subscribe to the stream!
stream.listen((DatabaseEvent event) {
  print('Event Type: ${event.type}'); // DatabaseEventType.value;
  print('Snapshot: ${event.snapshot}'); // DataSnapshot
});*/
}
