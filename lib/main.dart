import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openai_test/provider/api_key_provider.dart';
import 'package:flutter_openai_test/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ApiKeyProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter OpenAI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
          useMaterial3: true,
        ),
        // home: HomeScreen(),
        home: TestScreen(),
      ),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiKeyProvider = Provider.of<ApiKeyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Your OpenAI API Key"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "api key",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isEmpty ||
                    _textController.text == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong.....'),
                    ),
                  );
                } else {
                  apiKeyProvider.apiKey = _textController.text.trim();
                  debugPrint("${Provider.of<ApiKeyProvider>(context).apiKey}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Success.....'),
                    ),
                  );
                  // Navigate to HomeScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
