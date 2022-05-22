import 'package:flutter/cupertino.dart';

class Search {
  static List search({
    @required String searchText,
    @required List items,
    @required List<String> stringsToBeEliminated,
  }) {
    List listToBeReturned = [];
    if (stringsToBeEliminated != null && stringsToBeEliminated != 'null') {
      /*for (int i = 0; i < stringsToBeEliminated.length; i++) {
        if (stringsToBeEliminated[i]
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          // print('stringToBeEliminated: $stringToBeEliminated');
          print('stringToBeEliminated:');
          return [];
        }
      }*/
    }
    print('items: $items');
    items.forEach((item) {
      if (item.toString().toLowerCase().contains(searchText.toLowerCase())) {
        listToBeReturned.add(item);
      }
    });
    // print('listToBeReturned: $listToBeReturned');
    return listToBeReturned;
  }
}
