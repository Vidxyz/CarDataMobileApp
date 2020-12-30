import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_bloc.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_event.dart';
import 'package:car_data_app/src/blocs/advanced_search_bloc/advanced_search_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttributeValuesList extends StatefulWidget {
  final String attributeName;
  final List<String> attributeValues;
  final bool shouldShowSearchBar;

  AttributeValuesList({
    Key key,
    this.attributeName,
    this.attributeValues,
    this.shouldShowSearchBar
  }):
        super(key: key);

  @override
  State createState() {
    return _AttributeValuesListState();
  }
}

class _AttributeValuesListState extends State<AttributeValuesList> {

  AdvancedSearchBloc _advancedSearchBloc;
  List<String> _selectedItems = [];
  List<String> filteredAttributeValues = [];

  String searchQuery = "";
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _advancedSearchBloc = BlocProvider.of<AdvancedSearchBloc>(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocState = _advancedSearchBloc.state;
    final attributeValuesToShow = widget.attributeValues.where((element) =>
        element.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    if (blocState is AdvancedSearchCriteriaChanged) {
      final selectedAttributeValues = blocState.selectedFilters[widget.attributeName];
      if(selectedAttributeValues != null){
        _selectedItems = List<String>.from(selectedAttributeValues);
      }
      else _selectedItems = [];
    }
    else _selectedItems = [];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: _addSearchBarIfNeeded(widget.shouldShowSearchBar) + [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: attributeValuesToShow.length,
                itemBuilder: (_, index) {
                  return Container(
                    margin: EdgeInsets.only(left:17),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if(_selectedItems.contains(attributeValuesToShow[index]))
                          _selectedItems.remove(attributeValuesToShow[index]);
                        else
                          _selectedItems.add(attributeValuesToShow[index]);

                        _advancedSearchBloc.add(AdvancedSearchFiltersChanged(
                            selectedFilters: {widget.attributeName: _selectedItems}));
                      }),
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                            attributeValuesToShow[index].toString(),
                            style: TextStyle(
                                color: _selectedItems.contains(attributeValuesToShow[index]) ? Colors.tealAccent : Colors.white,
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _addSearchBarIfNeeded(bool shouldShowSearchBar) {
    if(!shouldShowSearchBar) return [];
    else return [
      Container(
        // color: Theme.of(context).primaryColor,
        child: ListTile(
          dense: true,
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
      ),
    ];
  }
}