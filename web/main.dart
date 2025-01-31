import 'package:web/web.dart' as web;
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;


// void main() {
//   final now = DateTime.now();
//   final element = web.document.querySelector('#output') as web.HTMLDivElement;
//   element.text = 'The time is ${now.hour}:${now.minute} '
//       'and your Dart web app is running!';
// }




void main() async {
  final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
  if (response.statusCode == 200) {
    final List<dynamic> countries = json.decode(response.body);
    displayCountries(countries);
  } else {
    print('Failed to load countries');
  }
}

void displayCountries(List<dynamic> countries) {
  final tbody = querySelector('#countries-table-body') as TableSectionElement;

  for (var country in countries) {
    final name = country['name']['common'];
    final capital = country['capital']?.first ?? 'N/A';
    final population = country['population'];
    final flag = country['flags']['png'];
    final currencies = country['currencies']?.values?.first['name'] ?? 'N/A';
    final languages = country['languages']?.values?.join(', ') ?? 'N/A';

    final pays = tbody.addRow();
    pays.addCell().append(ImageElement(src: flag, width: 50, height: 30));
    pays.addCell().text = name;
    pays.addCell().text = capital;
    pays.addCell().text = currencies;
    pays.addCell().text = languages;
    pays.addCell().text = population.toString();
    pays.addCell().append(ButtonElement()
      ..text = 'Supprimer'
      ..onClick.listen((event) {
        pays.remove();
      }));
  }
}