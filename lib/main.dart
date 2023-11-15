import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


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

  bool isDateFormatChanged = false;

  void toggleDateFormat() {
    isDateFormatChanged = !isDateFormatChanged;
    notifyListeners();
  }

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
        page = HomePage();
        break;
      case 1:
        page = Placeholder();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = Placeholder();
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: attendanceRecords.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(attendanceRecords[index].user),
            subtitle: Text('Phone: ${attendanceRecords[index].phone}\nCheck-in: ${attendanceRecords[index].checkIn}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(record: attendanceRecords[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  final AttendanceRecord record;
  const DetailScreen({required this.record, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.user),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Phone: ${record.phone}\nCheck-in: ${record.checkIn}'),
      ),
    );
  }
}

class AttendanceRecord {
  final String user;
  final String phone;
  final DateTime checkIn;
  AttendanceRecord(this.user, this.phone, this.checkIn);
}
List<AttendanceRecord> attendanceRecords = [
  AttendanceRecord('Chan Saw Lin', '0152131113', DateTime.parse('2020-06-30 16:10:05')),
  AttendanceRecord('Lee Saw Loy', '0161231346', DateTime.parse('2020-07-11 15:39:59')),];
