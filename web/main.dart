import 'package:web/web.dart' as web;
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

int currentPage = 0;
int countriesPerPage = 08;
List<dynamic> countries = [];

void main() async {
  final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
  if (response.statusCode == 200) {
    countries = json.decode(response.body);

     // Trier les pays par leur nom en ordre alphabétique
    countries.sort((a, b) => a['name']['common'].compareTo(b['name']['common']));

    displayCountries();
    setupPagination();
  } else {
    print('Failed to load countries');
  }
}

void displayCountries() {
  final tbody = querySelector('#countries-table-body') as TableSectionElement;
  tbody.children.clear();

  final start = currentPage * countriesPerPage;
  final end = start + countriesPerPage;
  final currentPageCountries = countries.sublist(start, end > countries.length ? countries.length : end);

  //
  for (var country in currentPageCountries) {
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

void setupPagination() {
  final paginationControls = querySelector('#pagination') as DivElement;
  final totalPages = (countries.length / countriesPerPage).ceil();

  paginationControls.children.clear(); 

  for (int i = 0; i < totalPages; i++) {
    final button = ButtonElement()
      ..text = (i + 1).toString()
      ..onClick.listen((event) {
        currentPage = i;
        displayCountries();
      });

    paginationControls.append(button);
  }
}
