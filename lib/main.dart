import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/screens/splash_screen.dart';
import 'package:message_bigtext_app/theme.dart';

import 'blocs/font_size_factor/bloc.dart';
import 'blocs/font_size_factor/event.dart';
import 'blocs/font_size_factor/state.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

///
/// running your application with "flutter run"
/// invoke "hot reload" (press "r" in the console where you ran "flutter run",
/// or simply save your changes to "hot reload" in a Flutter IDE)
///
/// ubuntu: flutter run -d firefox
///
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FontSizeBloc()..add(LoadFontSizeFactorEvent()),
      child: BlocBuilder<FontSizeBloc, FontSizeFactorState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Tin nhắn',
            theme: darkThemeData2(context).copyWith(
                textTheme: Theme.of(context)
                    .textTheme
                    .apply(fontSizeFactor: state.size)),
            builder: (context, widget) {
              return ScrollConfiguration(
                  behavior: ScrollBehaviorModified(), child: widget);
            },
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SplashScreen();
  }
}

/// https://stackoverflow.com/a/62810356
class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // switch (getPlatform(context)) {
    //   case TargetPlatform.iOS:
    //   case TargetPlatform.macOS:
    //   case TargetPlatform.android:
    //     return const BouncingScrollPhysics();
    //   case TargetPlatform.fuchsia:
    //   case TargetPlatform.linux:
    //   case TargetPlatform.windows:
    //     return const ClampingScrollPhysics();
    // }
    // return null;

    return const BouncingScrollPhysics();
  }
}
