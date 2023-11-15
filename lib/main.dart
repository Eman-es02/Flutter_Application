import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Attendance',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
      
    );
  }
}


class MyAppState extends ChangeNotifier {

}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const Placeholder();
        break;
      case 1:
        page = const Placeholder();
        break;
      case 2:
        page = const Placeholder();
        break;
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
}
        return Scaffold(
      body: Row(
        children: [
          SafeArea( //first child 
            child: NavigationRail(
              extended: false,
              destinations: const [
                NavigationRailDestination( //1
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination( //2
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
                NavigationRailDestination( //3
                  icon: Icon(Icons.date_range),
                  label: Text('Change Date Format'),
                ),
                NavigationRailDestination( //4
                  icon: Icon(Icons.add),
                  label: Text('Add Record'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
                
              },
            ),
          ),
          Expanded( // second child
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
