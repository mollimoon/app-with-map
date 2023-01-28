import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<LatLng> _placesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map page"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = _placesList[index];
          final data = '${item.latitude} ${item.longitude}';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data, style: const TextStyle(fontSize: 18),),
          );
        },
        itemCount: _placesList.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            //ждём пока не вернем результат
            context,
            MaterialPageRoute(builder: (context) {
              return const MapPage();
            }),
          );
          if (result == null) {
            return; //прервет выполнение onpressed и не будет ничего добавл в лист
          }
          setState(() {
            _placesList.add(result);
          });
        },
      ),
    );
  }
}