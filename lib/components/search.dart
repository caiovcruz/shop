import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final void Function(String) onSearch;

  const Search({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      onChanged: (value) => onSearch(value),
    );
  }
}
