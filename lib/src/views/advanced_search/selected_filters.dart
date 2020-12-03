import 'package:flutter/material.dart';

class SelectedFilters extends StatefulWidget {

  @override
  State createState() {
    return _SelectedFilters();
  }
}

class _SelectedFilters extends State<SelectedFilters> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: 250.0
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
              ),
            );
          }),
        ),
      ),
    );
  }

}