import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getResponse = 'Brak odpowiedzi';
  String _postResponse = 'Brak odpowiedzi';

  // Funkcja do wykonania zapytania GET
  Future<void> getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1'); // Przykładowy URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _getResponse = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          _getResponse = _handleHttpError(response.statusCode);
        });
      }
    } catch (error) {
      setState(() {
        _getResponse = 'Wystąpił błąd: $error';
      });
    }
  }

  // Funkcja do wykonania zapytania POST
  Future<void> postData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts'); // Przykładowy URL

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': 'foo',
          'body': 'bar',
          'userId': '1',
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _postResponse = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          _postResponse = _handleHttpError(response.statusCode);
        });
      }
    } catch (error) {
      setState(() {
        _postResponse = 'Wystąpił błąd: $error';
      });
    }
  }

  // Funkcja obsługująca różne kody statusu HTTP
  String _handleHttpError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Błąd 400: Bad Request – Serwer nie mógł zrozumieć zapytania.';
      case 401:
        return 'Błąd 401: Unauthorized – Użytkownik musi się uwierzytelnić.';
      case 403:
        return 'Błąd 403: Forbidden – Użytkownik nie ma dostępu do zasobu.';
      case 404:
        return 'Błąd 404: Not Found – Zasób nie został znaleziony.';
      case 500:
        return 'Błąd 500: Internal Server Error – Wewnętrzny błąd serwera.';
      case 503:
        return 'Błąd 503: Service Unavailable – Serwer jest niedostępny.';
      default:
        return 'Błąd: Nieznany kod błędu HTTP $statusCode';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo POST/GET'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: getData,
              child: Text('Wykonaj GET'),
            ),
            Text('Odpowiedź GET:'),
            Text(_getResponse),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: postData,
              child: Text('Wykonaj POST'),
            ),
            Text('Odpowiedź POST:'),
            Text(_postResponse),
          ],
        ),
      ),
    );
  }
}
