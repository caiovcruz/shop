import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final String hintText;
  final void Function(String) onSearch;

  const Search({
    Key? key,
    required this.hintText,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
        ),
        onChanged: (value) => onSearch(value),
      ),
    );
  }
}
