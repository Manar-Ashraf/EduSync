import 'package:flutter/material.dart';

class CourseSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> subjects;
  final Function(String) onSearch;

  CourseSearch(this.subjects, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> filteredList = subjects
        .where((subject) => subject['course'].contains(query))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredList[index]['course']),
          onTap: () {
            close(context, filteredList[index]['course']);
          },
        );
      },
    );
  }
}
