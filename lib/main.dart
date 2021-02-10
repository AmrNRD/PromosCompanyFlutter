
import 'package:PromoMeCompany/bloc/cycle/cycle_bloc.dart';
import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/data/repositories/cycle_repository.dart';
import 'package:PromoMeCompany/data/repositories/post_repository.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:PromoMeCompany/ui/modules/cycles/videos.tab.dart';
import 'package:PromoMeCompany/utils/sizeConfig.dart';

import 'app.dart';
import 'bloc/video/video_bloc.dart';
import 'env.dart';
import 'package:PromoMeCompany/data/repositories/settings_repositoy.dart';
import 'package:PromoMeCompany/ui/style/app.fonts.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'data/models/user_model.dart';
import 'data/repositories/user_repository.dart';
import 'utils/setup.dart';


void main() => runApp(Root());

class Root extends StatefulWidget {
  // This widget is the root of your application.
  static String fontFamily= AppFonts.fontTajawal;
  static Locale locale;
  static BuildContext appContext;
  static String firebaseToken;
  static ThemeMode themeMode=ThemeMode.system;
  static User user;


  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool localeLoaded = false;
  SettingsBloc settingsBloc;

  @override
  void initState() {
    setUp();
    super.initState();
  }

  Future<void> setUp() async {
    Root.appContext=context;

    settingsBloc=SettingsBloc(SettingsDataRepository());
    settingsBloc.add(LoadSettings());

    Root.firebaseToken =await SetUp.setUpFirebaseConfig(context);
  }

  changeFont(Locale locale){
    if(locale.languageCode=="ar")
      setState(() {
        Root.fontFamily = AppFonts.fontTajawal;
      });
    else
      setState(() {
        Root.fontFamily = AppFonts.fontSF;
      });
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc(UserDataRepository())),
        BlocProvider<PostBloc>(create: (BuildContext context) => PostBloc(PostDataRepository())),
        BlocProvider<CycleBloc>(create: (BuildContext context) => CycleBloc(CycleDataRepository())),
        BlocProvider<VideoBloc>(create: (BuildContext context) => VideoBloc(VideoDataRepository())),
        BlocProvider<StoreBloc>(create: (BuildContext context) => StoreBloc(StoreDataRepository())),
        BlocProvider<SettingsBloc>(create: (BuildContext context) => settingsBloc),
      ],
      child: BlocListener<SettingsBloc,SettingsState>(
        listener: (context,state){
          if (state is SettingsLoaded) {
            setState(() {
              Root.appContext=context;
              Root.themeMode=state.themeMode;
              Root.locale=state.locale;
              changeFont(Root.locale);
            });
          }else if (state is LocalLoaded) {
            setState(() {
              Root.locale=state.locale;
              changeFont(Root.locale);
            });
          }else if (state is ThemeModeLoaded) {
            setState(() {
              Root.themeMode=state.themeMode;
            });
          }
        },
        child:

    LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
    return OrientationBuilder(
    builder: (BuildContext context, Orientation orientation) {
    SizeConfig().init(constraints, orientation);
              return  MaterialApp(
                title: Env.appName,
                supportedLocales: application.supportedLocales(),
                builder: (context, child) {
                  return ScrollConfiguration(behavior: CustomScrollBehavior(), child: child);
                },
                theme: AppTheme(Root.fontFamily).lightModeTheme,
                darkTheme: AppTheme(Root.fontFamily).darkModeTheme,
                localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                locale: Root.locale,
                debugShowCheckedModeBanner: false,
                themeMode: Root.themeMode,
                onGenerateRoute: RouteGenerator().generateRoute,
              );
              });
    }
    )
      ),
    );
  }
}
