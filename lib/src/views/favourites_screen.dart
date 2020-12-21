import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {

  @override
  State createState() {
    return FavouritesScreenState();
  }
}

class FavouritesScreenState extends State<FavouritesScreen> {

  String searchQuery = "";
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _filterSearchBar(),
        _favouritesListView()
      ],
    );
  }

  Widget _favouritesListView() {
    return Text("Soon to come");
  }

  Widget _filterSearchBar() {
    return Card(
      child: ListTile(
        // dense: true,
        // leading: new Icon(Icons.search),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: 'Filter by typing...',
              border: InputBorder.none
          ),
          onChanged: (String text) {
            setState(() {
              searchQuery = text;
            });
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            controller.clear();
            setState(() {
              searchQuery = "";
            });
          },
        ),
      ),
    );
  }
}