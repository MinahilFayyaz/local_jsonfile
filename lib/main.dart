import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_jsonfile/items.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /*List _items= [];
  Future<void> readJson() async{
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await jsonDecode(response);
    setState(() {
      _items = data["items"];
      print("..number of items ${_items.length}");
    });
  }*/

  Future<List<ItemsDataModel>> readJsonData() async{

    final response =
    await DefaultAssetBundle.of(context).loadString('assets/sample.json');
    List data = await json.decode(response) as List<dynamic>;

    return data.map((e) => ItemsDataModel.fromJson(e)).toList();
  }


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Retrieve JSon data'),
      ),
      body: FutureBuilder(
        future: readJsonData(),
        builder: (context, data) {
          if( data.hasError)
            {
              return Center(
                child: Text("${data.error}"),);
            }
          else if(data.hasData)
            {
              var items = data.data as List<ItemsDataModel>;
              return ListView.builder(
                itemCount: items.length,
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                      child: ListTile(
                        leading: CircleAvatar(
                          //backgroundColor: Colors.transparent,
                          radius: 35,
                          backgroundImage: NetworkImage(items[index].imgUrl.toString()),
                        ),
                        title: Text(items[index].name.toString(),
                          style: const TextStyle( fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(items[index].description.toString(),
                          style: const TextStyle( fontSize: 18),),
                      ),
                    );
                  });
            }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}

