// ignore_for_file: prefer_const_constructors


/*
void main() {
  group('ThemeBloc', () {
    test('initial state is ThemeState', () {
      expect(ThemeBloc(themes: []).state, ThemeState());
    });

    group('ThemeChanged', () {
      late PuzzleTheme theme;

      blocTest<ThemeBloc, ThemeState>(
        'emits new theme',
        setUp: () => theme = MockPuzzleTheme(),
        build: () => ThemeBloc(themes: [MockPuzzleTheme(), theme]),
        act: (bloc) => bloc.add(ThemeChanged(themeIndex: 1)),
        expect: () => <ThemeState>[
          ThemeState(theme: theme),
        ],
      );
    });
  });
}*/
