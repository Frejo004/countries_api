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

//pagination des données récupérées
void setupPagination(List<dynamic> countries) {
  int currentPage = 1;
  const int itemsPerPage = 10;
  final int totalPages = (countries.length / itemsPerPage).ceil();

  void displayPage(int page) {
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    final paginatedCountries = countries.sublist(
      startIndex,
      endIndex < countries.length ? endIndex : countries.length,
    );
    displayCountries(paginatedCountries);
  }

  void updatePaginationControls() {
    final paginationDiv = querySelector('#pagination') as DivElement;
    paginationDiv.innerHtml = '';

    if (currentPage > 1) {
      final prevButton = ButtonElement()
        ..text = 'Précédent'
        ..onClick.listen((_) {
          currentPage--;
          displayPage(currentPage);
          updatePaginationControls();
        });
      paginationDiv.append(prevButton);
    }

    final pageInfo = SpanElement()..text = ' Page $currentPage / $totalPages ';
    paginationDiv.append(pageInfo);

    if (currentPage < totalPages) {
      final nextButton = ButtonElement()
        ..text = 'Suivant'
        ..onClick.listen((_) {
          currentPage++;
          displayPage(currentPage);
          updatePaginationControls();
        });
      paginationDiv.append(nextButton);
    }
  }

  displayPage(currentPage);
  updatePaginationControls();
}