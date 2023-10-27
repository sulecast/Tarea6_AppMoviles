import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Configuration'),
      routes: {
        '/genero': (context) => GeneroPage(),
        '/edad': (context) => EdadPage(),
        '/pais': (context) => PaisPage(),
        '/clima': (context) => ClimaPage(),
        '/wordpress': (context) => WordPressPage(),
        '/acercade': (context) => AcercadePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/genero');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Genero', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edad');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.pink,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Edad', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pais');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.pink,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('País', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clima');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.pink,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Clima', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/wordpress');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.pink,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Wordpress', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/acercade');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.pink,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Acerca de', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneroPage extends StatefulWidget {
  const GeneroPage({Key? key});

  @override
  _GeneroPageState createState() => _GeneroPageState();
}

class _GeneroPageState extends State<GeneroPage> {
  String name = '';
  String gender = '';

  Future<void> predictGender() async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        gender = data['gender'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predicción de Género'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          ElevatedButton(
            onPressed: () {
              predictGender();
            },
            child: Text('Predecir Género'),
          ),
          Text('Género: $gender'),
        ],
      ),
    );
  }
}

//Universidades en un pais

class PaisPage extends StatefulWidget {
  @override
  _PaisPageState createState() => _PaisPageState();
}

class _PaisPageState extends State<PaisPage> {
  List<University> universities = [];

  void fetchUniversities() async {
    final response = await http.get('http://universities.hipolabs.com/search?country=Dominican+Republic' as Uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<University> fetchedUniversities = List<University>.from(data.map((x) => University.fromJson(x)));
      setState(() {
        universities = fetchedUniversities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universidades en RD'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              fetchUniversities();
            },
            child: Text('Obtener Universidades'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: universities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(universities[index].name),
                  subtitle: Text(universities[index].domain),
                  onTap: () {
                  
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class University {
  final String name;
  final String domain;

  University({required this.name, required this.domain});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      domain: json['domains'][0],
    );
  }
}

//Clima en RD

class ClimaPage extends StatefulWidget {
  @override
  _ClimaPageState createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  WeatherFactory wf = WeatherFactory('https://www.weatherbit.io/');

  Weather? weather;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    weather = await wf.currentWeatherByLocation(19.2636, -70.3092); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en RD'),
      ),
      body: weather != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Temperatura: ${weather!.temp}°C'),
                Text('Condición: ${weather!.weatherDescription}'),
              ],
            )
          : CircularProgressIndicator(),
    );
  }
}

// Edad

class EdadPage extends StatefulWidget {
  @override
  _EdadPageState createState() => _EdadPageState();
}

class _EdadPageState extends State<EdadPage> {
  String name = '';
  int age = 0;
  String ageCategory = '';
  String imageAsset = '';

  void predictAge() async {
    final response = await http.get('https://api.agify.io/?name=$name' as Uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        age = data['age'];
        // Determinar la categoría de edad
        if (age < 18) {
          ageCategory = 'Joven';
          imageAsset = 'assets/joven.jpg'; 
        } else if (age < 60) {
          ageCategory = 'Adulto';
          imageAsset = 'assets/adulto.jpg'; 
        } else {
          ageCategory = 'Anciano';
          imageAsset = 'assets/anciano.jpg'; 
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predicción de Edad'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          ElevatedButton(
            onPressed: () {
              predictAge();
            },
            child: Text('Predecir Edad'),
          ),
          if (ageCategory.isNotEmpty)
            Column(
              children: [
                Text('Edad: $age años'),
                Text('Categoría de Edad: $ageCategory'),
                Image.asset(imageAsset), // Mostrar la imagen correspondiente.
              ],
            ),
        ],
      ),
    );
  }
}

//wordpress

class WordPressPage extends StatefulWidget {
  @override
  _WordPressPageState createState() => _WordPressPageState();
}

class _WordPressPageState extends State<WordPressPage> {
  List<WordPressNews> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchWordPressNews();
  }

  void fetchWordPressNews() async {
    final response = await http.get('https://www.bbc.co.uk/blogs/radiolabs' as Uri);
    if (response.statusCode == 200) {
      final document = parse(response.body); // Utiliza un paquete HTML parser como 'html'.
      final logoUrl = document.querySelector('.site-logo img')?.attributes['src'];

      final List<Element> articles = document.querySelectorAll('article');
      for (var article in articles.take(3)) {
        final title = article.querySelector('.entry-title a').text;
        final summary = article.querySelector('.entry-content p').text;
        final link = article.querySelector('.entry-title a').attributes['href'];

        final news = WordPressNews(title, summary, link, logoUrl!);
        setState(() {
          newsList.add(news);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias de WordPress'),
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(newsList[index].title),
            subtitle: Text(newsList[index].summary),
            leading: Image.network(newsList[index].logoUrl),
            onTap: () {
              // Navegar a la noticia original en el navegador.
              launch(newsList[index].link);
            },
          );
        },
      ),
    );
  }
}

class WordPressNews {
  final String title;
  final String summary;
  final String link;
  final String logoUrl;

  WordPressNews(this.title, this.summary, this.link, this.logoUrl);
}

//acerca de

class AcercadePage extends StatelessWidget {
  const AcercadePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de:'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Agregar tu foto de perfil
            Container(
              margin: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/suleika.jpg"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: Suleika Mercedes',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: suleika159@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Teléfono: 829-751-0360',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
