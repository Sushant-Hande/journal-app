import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff336940),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb5f1bc),
      onPrimaryContainer: Color(0xff19512a),
      secondary: Color(0xff34693f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb6f1bb),
      onSecondaryContainer: Color(0xff1b5129),
      tertiary: Color(0xff586420),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffdcea97),
      onTertiaryContainer: Color(0xff414b08),
      error: Color(0xff904a43),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff73332d),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff717970),
      outlineVariant: Color(0xffc1c9be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xffb5f1bc),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff19512a),
      secondaryFixed: Color(0xffb6f1bb),
      onSecondaryFixed: Color(0xff00210a),
      secondaryFixedDim: Color(0xff9bd4a0),
      onSecondaryFixedVariant: Color(0xff1b5129),
      tertiaryFixed: Color(0xffdcea97),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffc0ce7e),
      onTertiaryFixedVariant: Color(0xff414b08),
      surfaceDim: Color(0xffd6dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffeaefe8),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff023f1b),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff42794e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff043f1a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff43784d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff313a00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff67732e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e231e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa25850),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff0d120e),
      onSurfaceVariant: Color(0xff313831),
      outline: Color(0xff4d544c),
      outlineVariant: Color(0xff676f66),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xff42794e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff295f37),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff43784d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2a5f36),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff67732e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4f5a17),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8c1),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffe5eae2),
      surfaceContainerHigh: Color(0xffd9ded7),
      surfaceContainerHighest: Color(0xffced3cc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003414),
      surfaceTint: Color(0xff336940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c532c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003413),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1e532b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff283000),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff434e0b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511a15),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff76362f),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272e27),
      outlineVariant: Color(0xff444b43),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff9ad4a2),
      primaryFixed: Color(0xff1c532c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003c18),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1e532b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003c17),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff434e0b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2e3600),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab3),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf2eb),
      surfaceContainer: Color(0xffdfe4dd),
      surfaceContainerHigh: Color(0xffd1d6cf),
      surfaceContainerHighest: Color(0xffc3c8c1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9ad4a2),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff003917),
      primaryContainer: Color(0xff19512a),
      onPrimaryContainer: Color(0xffb5f1bc),
      secondary: Color(0xff9bd4a0),
      onSecondary: Color(0xff003915),
      secondaryContainer: Color(0xff1b5129),
      onSecondaryContainer: Color(0xffb6f1bb),
      tertiary: Color(0xffc0ce7e),
      onTertiary: Color(0xff2c3400),
      tertiaryContainer: Color(0xff414b08),
      onTertiaryContainer: Color(0xffdcea97),
      error: Color(0xffffb4ab),
      onError: Color(0xff561e19),
      errorContainer: Color(0xff73332d),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101510),
      onSurface: Color(0xffdfe4dd),
      onSurfaceVariant: Color(0xffc1c9be),
      outline: Color(0xff8b9389),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff336940),
      primaryFixed: Color(0xffb5f1bc),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff19512a),
      secondaryFixed: Color(0xffb6f1bb),
      onSecondaryFixed: Color(0xff00210a),
      secondaryFixedDim: Color(0xff9bd4a0),
      onSecondaryFixedVariant: Color(0xff1b5129),
      tertiaryFixed: Color(0xffdcea97),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffc0ce7e),
      onTertiaryFixedVariant: Color(0xff414b08),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafebb6),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff002d10),
      primaryContainer: Color(0xff659d6f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb0eab5),
      onSecondary: Color(0xff002d0f),
      secondaryContainer: Color(0xff669d6e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd6e491),
      onTertiary: Color(0xff222900),
      tertiaryContainer: Color(0xff8a974d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff48130f),
      errorContainer: Color(0xffcc7b72),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dfd4),
      outline: Color(0xffacb4aa),
      outlineVariant: Color(0xff8b9289),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff1b522b),
      primaryFixed: Color(0xffb5f1bc),
      onPrimaryFixed: Color(0xff001505),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff023f1b),
      secondaryFixed: Color(0xffb6f1bb),
      onSecondaryFixed: Color(0xff001505),
      secondaryFixedDim: Color(0xff9bd4a0),
      onSecondaryFixedVariant: Color(0xff043f1a),
      tertiaryFixed: Color(0xffdcea97),
      onTertiaryFixed: Color(0xff0f1300),
      tertiaryFixedDim: Color(0xffc0ce7e),
      onTertiaryFixedVariant: Color(0xff313a00),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff404641),
      surfaceContainerLowest: Color(0xff050805),
      surfaceContainerLow: Color(0xff1a1f1a),
      surfaceContainer: Color(0xff242925),
      surfaceContainerHigh: Color(0xff2f342f),
      surfaceContainerHighest: Color(0xff3a3f3a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc2ffc9),
      surfaceTint: Color(0xff9ad4a2),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff96d09e),
      onPrimaryContainer: Color(0xff000f03),
      secondary: Color(0xffc3ffc8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff97d09d),
      onSecondaryContainer: Color(0xff000f03),
      tertiary: Color(0xffeaf8a3),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbcca7a),
      onTertiaryContainer: Color(0xff090d00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf2e7),
      outlineVariant: Color(0xffbdc5ba),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inversePrimary: Color(0xff1b522b),
      primaryFixed: Color(0xffb5f1bc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9ad4a2),
      onPrimaryFixedVariant: Color(0xff001505),
      secondaryFixed: Color(0xffb6f1bb),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff9bd4a0),
      onSecondaryFixedVariant: Color(0xff001505),
      tertiaryFixed: Color(0xffdcea97),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc0ce7e),
      onTertiaryFixedVariant: Color(0xff0f1300),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff4c514c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211c),
      surfaceContainer: Color(0xff2c322d),
      surfaceContainerHigh: Color(0xff373d38),
      surfaceContainerHighest: Color(0xff434843),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
