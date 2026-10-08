import '../utils/shared_import.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: whiteColor,
    primaryColor: primaryColor,
    iconTheme: const IconThemeData(color: Colors.black),
    dividerColor: viewLineColor,
    cardColor: cardLightColor,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.white,
      // background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      // onBackground: Colors.black,
      onError: Colors.redAccent,
      brightness: Brightness.light,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: radius(20),
        side: const BorderSide(color: primaryColor),
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: scaffoldColorDark,
    iconTheme: const IconThemeData(color: Colors.white),
    cardColor: cardDarkColor,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.black,
      //  background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      // onBackground: Colors.white,
      onError: Colors.redAccent,
      brightness: Brightness.dark,
    ),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: primaryColor,
      headerForegroundColor: Colors.white,
      backgroundColor: scaffoldColorDark,
      dayForegroundColor: WidgetStateProperty.all(Colors.white),
      yearForegroundColor: WidgetStateProperty.all(Colors.white),
      rangePickerHeaderBackgroundColor: primaryColor,
      rangePickerHeaderForegroundColor: Colors.white,
      dayStyle: primaryTextStyle(color: Colors.white),
    ),
    dividerColor: Colors.white24,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: radius(20),
        side: const BorderSide(color: primaryColor),
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
