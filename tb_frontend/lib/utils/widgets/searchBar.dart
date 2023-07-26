
import 'package:flutter/material.dart';

/// This class is used to display a search bar.
///
/// It is used to filter entites based on the filter searchResult.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class SearchBar extends StatelessWidget {
  final TextEditingController editingController;
  final Function(String) filterSearchResults;


  const SearchBar(this.editingController, this.filterSearchResults, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value);
        },
        controller: editingController,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}