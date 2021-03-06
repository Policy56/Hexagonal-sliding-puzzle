# Hexagonal sliding puzzle

![Photo Booth Header][logo]

![coverage][coverage_badge]
[![Last Commits](https://img.shields.io/github/last-commit/Policy56/Hexagonal-sliding-puzzle?logo=git&logoColor=white)](https://github.com/Policy56/Hexagonal-sliding-puzzle/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/Policy56/Hexagonal-sliding-puzzle?logo=github&logoColor=white)](https://github.com/Policy56/Hexagonal-sliding-puzzle/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Policy56/Hexagonal-sliding-puzzle?logo=github&logoColor=white)](https://github.com/Policy56/Hexagonal-sliding-puzzle)
[![wakatime](https://wakatime.com/badge/user/f8171f0c-de06-4c7b-954a-3f97ba58c2c4/project/a0c47554-0945-487b-b5ef-535a2bf67bd5.svg)](https://wakatime.com/badge/user/f8171f0c-de06-4c7b-954a-3f97ba58c2c4/project/a0c47554-0945-487b-b5ef-535a2bf67bd5)

[![Deploy to Firebase Hosting on merge](https://github.com/Policy56/Hexagonal-sliding-puzzle/actions/workflows/firebase-hosting-merge.yml/badge.svg?branch=master)](https://github.com/Policy56/Hexagonal-sliding-puzzle/actions/workflows/firebase-hosting-merge.yml)
[![Deploy to AppStore](https://github.com/Policy56/Hexagonal-sliding-puzzle/actions/workflows/flutter_deploy.yaml/badge.svg?branch=master)](https://github.com/Policy56/Hexagonal-sliding-puzzle/actions/workflows/flutter_deploy.yaml)
[![License: MIT][license_badge]][license_link]

A new way of sliding puzzle built for [Flutter Challenge](https://flutterhack.devpost.com/).

*Built by [Policy56][policy_link], a 25yo mobile developer*

---

## Link 🎮

The game is multiplatform, play it here :

🌍 Web : [Link](https://hexagonal-sliding-puzzle.web.app/#/)

🤖 Android : [Link](https://play.google.com/store/apps/details?id=com.policy.hexagonalslidingpuzzle)

🍎 Ios : [Link](https://apps.apple.com/app/id1609083334)

---

## Getting Started 🚀

To run the project either use the launch configuration in VSCode/Android Studio or use the following command with last flutter release :

```sh
$ flutter run -d chrome
```

If error on build :

```sh
$ flutter packages pub run build_runner build
```


---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Reportsty
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

The app is translate in english and french.

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[policy_link]: https://www.christophecolineaux.fr/
[logo]: art/header.png
