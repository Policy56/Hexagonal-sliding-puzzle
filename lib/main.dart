// Copyright (c) 2021, Christophe COLINEAUX
// https://www.christophecolineaux.fr
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hexagonal_sliding_puzzle/app/app.dart';
import 'package:hexagonal_sliding_puzzle/bootstrap.dart';
import 'package:hexagonal_sliding_puzzle/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await bootstrap(() => const App());
}
