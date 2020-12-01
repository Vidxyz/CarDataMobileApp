import 'package:flutter/cupertino.dart';

class AdvancedSearchScreen extends StatefulWidget {

  @override
  State createState() {
    return _AdvancedSearchScreenState();
  }
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {

  // this is so that the framework doesn't dispose
  // @override
  // bool wantKeepAlive = true;

  // AppPropertiesBloc _appPropertiesBloc;

  @override
  void initState() {
    super.initState();
    // _appPropertiesBloc = BlocProvider.of<AppPropertiesBloc>(context);
    // print("App bar update command being sent now");
    // _appPropertiesBloc.updateTitle("Search Vehicles");
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("More content to come soon...")
    );
  }

}