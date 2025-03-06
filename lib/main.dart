import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 90, 248, 248)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = _getRandomSpanishWord();

  static final List<String> _spanishWords = [
    'perro', 'gato', 'cielo', 'sol', 'luna', 'flor', 'río', 'montaña', 'bosque', 'mar',
    'estrella', 'noche', 'día', 'madera', 'piedra', 'nieve', 'viento', 'árbol', 'luz', 'agua',
    'arepa', 'barranquilla', 'café', 'sancocho', 'tinto', 'chiva', 'bambuco', 'vallenato', 'patacón', 'empanada',
    'moñona', 'bacano', 'chocolate', 'hijo de puta', 'pelado', 'parcero', 'mamerto', 'marica', 'guevón', 'paila',
    'cuchibarro', 'cucho', 'pucha', 'pique', 'chiquito', 'mamar gallo', 'guayabo', 'sillón', 'cachaco', 'madrugar',
    'churro', 'viche', 'guandolo', 'guarapo', 'machete', 'tinto', 'palo', 'aguacate', 'alpargata', 'cucaracha',
    'vibrón', 'trabajo', 'volador', 'finca', 'rolo', 'lucha', 'conchudo', 'quimba', 'salchichón', 'tía', 'coso',
    'panela', 'rumba', 'marimonda', 'chiquitear', 'romerillo', 'yuca', 'guapetón', 'pupusa', 'trote', 'cañaguate',
    'chicharrón', 'guerrero', 'alebrijes', 'súper', 'cucho', 'bollo', 'peluquear', 'carretón', 'bici', 'ranchera',
    'bocadillo', 'mujerón', 'cambuche', 'lavadero', 'mamera', 'guacherna', 'calentura', 'motilón', 'cantaleta',
    'patrón', 'nochebuena', 'caleta', 'corte', 'pesa', 'boca', 'chisme', 'relajo', 'zancudo', 'calor', 'fondo',
    'chamba', 'tropel', 'rompecabezas', 'chaleco', 'sastre', 'verde', 'salsito', 'guainía', 'cervecero', 'nene',
    'fiesta', 'aguacero', 'patá', 'pilla', 'guayaba', 'correr', 'trote', 'sangre', 'mojo', 'güiro', 'despacho'
];


  static String _getRandomSpanishWord() {
    final random = Random();
    return _spanishWords[random.nextInt(_spanishWords.length)];
  }

  void getNext() {
    current = _getRandomSpanishWord();
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  var selectedIndex = 0;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favoritos'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('Sin favoritos aún'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Tienes ${appState.favorites.length} en favoritos:'),
        ),
        for (var word in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(word),
          ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var word = appState.current;

    IconData icon;
    if (appState.favorites.contains(word)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(word: word),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Me gusta'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Siguiente'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.word,
  });

  final String word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          word,
          style: style,
        ),
      ),
    );
  }
}
