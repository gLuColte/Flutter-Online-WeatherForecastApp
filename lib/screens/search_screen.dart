import 'package:flutter/material.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String cityName;

  @override
  String deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    if (cityName != null){
      return cityName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              MapBoxPlaceSearchWidget(
                popOnSelect: true,
                apiKey:
                    "pk.eyJ1IjoidGVsbG1hd2h5IiwiYSI6ImNrbDIxOWg1ZjAwNGsybmxhendkaGdtem8ifQ.8x49f4tFrIe9eiJZ0oHCSQ",
                searchHint: 'Enter City Here',
                onSelected: (place) {
                  cityName = place.toString();
                  Navigator.pop(
                    context, cityName,
                  );
                },
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
