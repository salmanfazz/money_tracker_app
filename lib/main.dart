import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_tracker_app/Screens/home.dart';
import 'package:money_tracker_app/data/model/add_date.dart';
import 'package:money_tracker_app/pages/home_page_supabase.dart';
import 'package:money_tracker_app/pages/signin_page.dart';
import 'package:money_tracker_app/pages/signup_page.dart';
import 'package:money_tracker_app/pages/utils/utils.dart';
import 'package:money_tracker_app/widgets/bottomnavigationbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://crlzxteldlucafxrbghv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNybHp4dGVsZGx1Y2FmeHJiZ2h2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzE4ODEyMzIsImV4cCI6MTk4NzQ1NzIzMn0.Tr6gVDStZsZly_OZZRhsEpmuuUiUSmFL34jVgNzM2OI',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: client.auth.currentSession != null ? '/home' : '/',
      routes: {
        '/': (context) => const MyWidget(),
        '/home': (context) => const Bottom(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Money Tracker',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: const Text('Sign In'),
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Sign Up')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
