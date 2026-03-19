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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
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
  bool _firstClick = true;
  int _requestCount = 0;
  bool _isCelsius = true; // БАГ 10: Переключение единиц не работает
  
  // Для бага с датой
  DateTime _lastUpdate = DateTime.now();
  
  final List<Color> _gradientColors = [
    Color(0xFF6DD5FA),
    Color(0xFF2980B9),
  ];

  // 16 городов с данными
  final Map<String, Map<String, dynamic>> _mockData = {
    // Россия
    'moscow': {
      'temp': '32°F', 'desc': 'облачно', 'icon': '☁️', 
      'feels': '28°F', 'wind': '5 м/с', 'humidity': '75%',
      'pressure': '745 мм', 'visibility': '10 км'
    },
    'saint petersburg': {
      'temp': '30°F', 'desc': 'дождь', 'icon': '🌧️', 
      'feels': '25°F', 'wind': '7 м/с', 'humidity': '85%',
      'pressure': '740 мм', 'visibility': '8 км'
    },
    'kazan': {
      'temp': '28°F', 'desc': 'снег', 'icon': '🌨️', 
      'feels': '22°F', 'wind': '4 м/с', 'humidity': '80%',
      'pressure': '750 мм', 'visibility': '5 км'
    },
    'novosibirsk': {
      'temp': '25°F', 'desc': 'морозно', 'icon': '❄️', 
      'feels': '18°F', 'wind': '3 м/с', 'humidity': '70%',
      'pressure': '755 мм', 'visibility': '7 км'
    },
    'sochi': {
      'temp': '50°F', 'desc': 'солнечно', 'icon': '☀️', 
      'feels': '48°F', 'wind': '2 м/с', 'humidity': '60%',
      'pressure': '760 мм', 'visibility': '20 км'
    },
    'ekaterinburg': {
      'temp': '27°F', 'desc': 'пасмурно', 'icon': '☁️', 
      'feels': '23°F', 'wind': '4 м/с', 'humidity': '78%',
      'pressure': '748 мм', 'visibility': '6 км'
    },
    
    // Европа
    'london': {
      'temp': '59°F', 'desc': 'туман', 'icon': '🌫️', 
      'feels': '55°F', 'wind': '6 м/с', 'humidity': '90%',
      'pressure': '742 мм', 'visibility': '3 км'
    },
    'paris': {
      'temp': '63°F', 'desc': 'ясно', 'icon': '☀️', 
      'feels': '60°F', 'wind': '4 м/с', 'humidity': '65%',
      'pressure': '752 мм', 'visibility': '15 км'
    },
    'berlin': {
      'temp': '61°F', 'desc': 'облачно', 'icon': '⛅', 
      'feels': '58°F', 'wind': '5 м/с', 'humidity': '70%',
      'pressure': '749 мм', 'visibility': '12 км'
    },
    'rome': {
      'temp': '68°F', 'desc': 'солнечно', 'icon': '☀️', 
      'feels': '65°F', 'wind': '3 м/с', 'humidity': '55%',
      'pressure': '758 мм', 'visibility': '18 км'
    },
    'barcelona': {
      'temp': '70°F', 'desc': 'ясно', 'icon': '☀️', 
      'feels': '68°F', 'wind': '4 м/с', 'humidity': '50%',
      'pressure': '761 мм', 'visibility': '20 км'
    },
    'amsterdam': {
      'temp': '57°F', 'desc': 'дождь', 'icon': '🌧️', 
      'feels': '54°F', 'wind': '8 м/с', 'humidity': '88%',
      'pressure': '739 мм', 'visibility': '4 км'
    },
    
    // США
    'new york': {
      'temp': '72°F', 'desc': 'солнечно', 'icon': '☀️', 
      'feels': '70°F', 'wind': '6 м/с', 'humidity': '60%',
      'pressure': '755 мм', 'visibility': '16 км'
    },
    'los angeles': {
      'temp': '75°F', 'desc': 'ясно', 'icon': '☀️', 
      'feels': '73°F', 'wind': '3 м/с', 'humidity': '45%',
      'pressure': '763 мм', 'visibility': '22 км'
    },
    'chicago': {
      'temp': '65°F', 'desc': 'ветрено', 'icon': '💨', 
      'feels': '60°F', 'wind': '10 м/с', 'humidity': '55%',
      'pressure': '746 мм', 'visibility': '11 км'
    },
    'miami': {
      'temp': '80°F', 'desc': 'жарко', 'icon': '🔥', 
      'feels': '85°F', 'wind': '5 м/с', 'humidity': '70%',
      'pressure': '759 мм', 'visibility': '14 км'
    },
    
    // Азия
    'tokyo': {
      'temp': '68°F', 'desc': 'пасмурно', 'icon': '☁️', 
      'feels': '65°F', 'wind': '4 м/с', 'humidity': '65%',
      'pressure': '751 мм', 'visibility': '13 км'
    },
    'bali': {
      'temp': '82°F', 'desc': 'дождь', 'icon': '🌧️', 
      'feels': '80°F', 'wind': '2 м/с', 'humidity': '80%',
      'pressure': '757 мм', 'visibility': '9 км'
    },
    'seoul': {
      'temp': '64°F', 'desc': 'облачно', 'icon': '☁️', 
      'feels': '62°F', 'wind': '5 м/с', 'humidity': '72%',
      'pressure': '753 мм', 'visibility': '12 км'
    },
    'beijing': {
      'temp': '60°F', 'desc': 'смог', 'icon': '😷', 
      'feels': '58°F', 'wind': '4 м/с', 'humidity': '68%',
      'pressure': '744 мм', 'visibility': '2 км'
    },
  };

  void _getWeather() async {
    // БАГ 1: Кнопка не работает с первого раза
    if (_firstClick) {
      _firstClick = false;
      setState(() {
        _error = '👉 Нажмите ещё раз (баг #1)';
      });
      return;
    }

    String city = _cityController.text.toLowerCase().trim();
    
    // БАГ 2: Нет проверки на пустой город (но мы добавим её с багом)
    if (city.isEmpty) {
      setState(() {
        _error = '⚠️ Введите город (баг #2 - сообщение появляется не сразу)';
      });
      return;
    }

    // БАГ 5: Нет индикатора загрузки
    await Future.delayed(Duration(seconds: 2));
    
    // БАГ 11: Рандомные ошибки (иногда падает даже с правильным городом)
    if (DateTime.now().second % 3 == 0) {
      setState(() {
        _error = '🌪️ Сервер временно недоступен (баг #11)';
      });
      return;
    }
    
    // БАГ 7: Чувствительность к регистру и лишние пробелы
    if (!_mockData.containsKey(city)) {
      setState(() {
        _error = '❌ Город "$city" не найден (баг #7)';
      });
      return;
    }

    // БАГ 3: Данные не обновляются если город тот же
    if (_cityName.toLowerCase() == city) {
      setState(() {
        _error = '🔄 Данные не обновляются (баг #3)';
      });
      return;
    }

    // БАГ 9: Лимит запросов
    _requestCount++;
    if (_requestCount > 3) {
      setState(() {
        _error = '⛔ Превышен лимит запросов (баг #9)';
      });
      return;
    }

    // БАГ 12: Данные устарели (показывает старые данные)
    if (_lastUpdate.isBefore(DateTime.now().subtract(Duration(minutes: 5)))) {
      setState(() {
        _error = '📅 Данные устарели (баг #12)';
      });
      // Но всё равно показываем
    }

    setState(() {
      var data = _mockData[city]!;
      _cityName = city;
      _temperature = data['temp'];
      _description = data['desc'];
      _error = '';
      _lastUpdate = DateTime.now();
    });
  }

  // БАГ 10: Переключение единиц не работает
  void _toggleUnits() {
    setState(() {
      _isCelsius = !_isCelsius;
      if (_temperature.isNotEmpty) {
        // Ничего не меняем - баг!
      }
    });
  }

  // БАГ 8: Старые данные не очищаются
  void _clearData() {
    // Должно очищать, но не очищает
    // _cityName = '';
    // _temperature = '';
    // _description = '';
    setState(() {
      _error = 'Данные не очистились (баг #8)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Красивый заголовок
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '🌤 Weather App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '20+ городов по всему миру',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Основной контент
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        // Поле ввода
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'Поиск города',
                              hintText: 'moscow, london, paris...',
                              prefixIcon: Icon(Icons.search, color: Colors.blue),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: _clearData, // БАГ 8
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 15),
                        
                        // Кнопки
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.lightBlueAccent],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _getWeather,
                                  child: Text(
                                    'Узнать погоду',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // БАГ 6: Кнопка переключения зависает
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isCelsius ? Icons.thermostat : Icons.thermostat_auto,
                                  color: Colors.blue[800],
                                ),
                                onPressed: _toggleUnits, // БАГ 10
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Сообщение об ошибке
                        if (_error.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.red[100]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _error,
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        // Карточка погоды
                        if (_cityName.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(25),
                                      child: Column(
                                        children: [
                                          // Город и иконка
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _mockData[_cityName]?['icon'] ?? '🌤️',
                                                style: TextStyle(fontSize: 60),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                _cityName.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          SizedBox(height: 20),
                                          
                                          // Температура
                                          Text(
                                            _temperature,
                                            style: TextStyle(
                                              fontSize: 64,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 5,
                                                  color: Colors.blue[200]!,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Описание
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              _description,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue[900],
                                              ),
                                            ),
                                          ),
                                          
                                          SizedBox(height: 25),
                                          
                                          // Дополнительная информация
                                          GridView.count(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            crossAxisCount: 2,
                                            childAspectRatio: 2.5,
                                            children: [
                                              _buildInfoItem('🌡️ Ощущается', _mockData[_cityName]?['feels'] ?? '—'),
                                              _buildInfoItem('💨 Ветер', _mockData[_cityName]?['wind'] ?? '—'),
                                              _buildInfoItem('💧 Влажность', _mockData[_cityName]?['humidity'] ?? '—'),
                                              _buildInfoItem('📊 Давление', _mockData[_cityName]?['pressure'] ?? '—'),
                                              _buildInfoItem('👁 Видимость', _mockData[_cityName]?['visibility'] ?? '—'),
                                              // БАГ 4: Повторяющиеся данные
                                              _buildInfoItem('🌡️ Ощущается', _mockData[_cityName]?['feels'] ?? '—'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 20),
                                  
                                  // Список доступных городов
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_city, color: Colors.blue),
                                            SizedBox(width: 10),
                                            Text(
                                              'Доступные города:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        // БАГ 4: Дублирование городов
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            ..._mockData.keys.take(10).map((city) => 
                                              Chip(
                                                label: Text(city),
                                                backgroundColor: Colors.blue[50],
                                              ),
                                            ),
                                            ..._mockData.keys.take(5).map((city) => // Дубликаты
                                              Chip(
                                                label: Text(city),
                                                backgroundColor: Colors.blue[50],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
