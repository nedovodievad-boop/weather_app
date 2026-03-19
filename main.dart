import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _cityName = '';
  String _description = '';
  String _error = '';
  bool _firstClick = true; // БАГ: Для кнопки которая не работает с первого раза

  // БАГ: Mock данные с неправильной температурой (в фаренгейтах)
  final Map<String, Map<String, dynamic>> _mockData = {
    'moscow': {
      'temp': '32°F', // Должно быть 0°C
      'description': 'облачно',
      'icon': '☁️',
    },
    'london': {
      'temp': '59°F', // Должно быть 15°C
      'description': 'дождь',
      'icon': '🌧️',
    },
    'new york': {
      'temp': '72°F', // Должно быть 22°C
      'description': 'солнечно',
      'icon': '☀️',
    },
  };

  // БАГ: Функция с багами
  void _getWeather() async {
    // БАГ 1: Кнопка не работает с первого раза
    if (_firstClick) {
      _firstClick = false;
      setState(() {
        _error = 'Нажмите ещё раз (баг #1)';
      });
      return;
    }

    String city = _cityController.text.toLowerCase().trim();
    // БАГ 2: Ошибка при несуществующем городе
    if (!_mockData.containsKey(city)) {
      setState(() {
        _error = 'Ошибка: Город не найден (баг #2)';
      });
      return;
    }

    // БАГ 3: Данные не обновляются если город тот же
    if (_cityName.toLowerCase() == city) {
      setState(() {
        _error = 'Данные не обновляются (баг #3)';
      });
      return;
    }

    setState(() {
      var data = _mockData[city]!;
      _cityName = city;
      _temperature = data['temp'];
      _description = data['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Поле ввода
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Введите город',
                border: OutlineInputBorder(),
                hintText: 'например: moscow',
              ),
            ),
            
            SizedBox(height: 20),
            
            // Кнопка
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Узнать погоду'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Ошибки
            if (_error.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.red[100],
                child: Text(
                  _error,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            
            // Погода
            if (_cityName.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _cityName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _temperature,
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _description,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      // Иконка (упрощённо)
                      Text(
                        _mockData[_cityName]?['icon'] ?? '🌤️',
                        style: TextStyle(fontSize: 50),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}