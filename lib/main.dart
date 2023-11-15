import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppState()),
      ],
      child: const MyApp(),
    ),
  );
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
  String searchKeyword = '';

  void toggleDateFormat() {
    isDateFormatChanged = !isDateFormatChanged;
    notifyListeners();
  }

   void setSearchKeyword(String keyword) {
    searchKeyword = keyword;
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
    final appState = Provider.of<MyAppState>(context, listen: false);
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage(isDateFormatChanged: appState.isDateFormatChanged);
        break;
      case 1:
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
              labelType: NavigationRailLabelType.selected,
              extended: false,

              destinations: const [
                NavigationRailDestination( //1
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                
                NavigationRailDestination( //2
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
              leading: Column (
                children: [
                 const SizedBox(height: 8.0,),
                 Switch(
                  value: appState.isDateFormatChanged,
                  onChanged: (value) {
                    setState(() {
                      appState.toggleDateFormat();
                    });
                  },
                  activeTrackColor: Color.fromARGB(255, 247, 202, 255),
                  activeColor:  Color.fromARGB(255, 153, 0, 180),
                 ), 
                ]),
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
  final bool isDateFormatChanged;

  HomePage({required this.isDateFormatChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(),
        Expanded(
          child: RecordList(isDateFormatChanged: isDateFormatChanged),
        ),
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          appState.setSearchKeyword(value);
        },
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class RecordList extends StatelessWidget {
  final bool isDateFormatChanged;

  RecordList({required this.isDateFormatChanged});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context, listen: true);

    List<AttendanceRecord> filteredRecords = appState.searchKeyword.isEmpty
        ? attendanceRecords
        : attendanceRecords
            .where((record) =>
                record.user.toLowerCase().contains(appState.searchKeyword.toLowerCase()) ||
                record.phone.contains(appState.searchKeyword))
            .toList();

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        final checkIn = isDateFormatChanged
            ? DateFormat('dd MMM yyyy, h:mm a').format(record.checkIn)
            : timeago.format(record.checkIn);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(record.user),
            subtitle: Text('Phone: ${record.phone}\nCheck-in: $checkIn'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(record: record),
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
  AttendanceRecord('Lee Saw Loy', '0161231346', DateTime.parse('2020-07-11 15:39:59')),
  AttendanceRecord('Khaw Tong Lin', '0158398109', DateTime.parse('2020-08-19 11:10:18')),
  AttendanceRecord('Lim Kok Lin', '0168279101', DateTime.parse('2020-08-19 11:11:35')),
  AttendanceRecord('Low Jun Wei', '0112731912', DateTime.parse('2020-08-15 13:00:05')),
  AttendanceRecord('Yong Weng Kai', '0172332743', DateTime.parse('2020-07-31 18:10:11')),
  AttendanceRecord('Jayden Lee', '0191236439', DateTime.parse('2020-08-22 08:10:38')),
  AttendanceRecord('Kong Kah Yan', '0111931233', DateTime.parse('2020-07-11 12:00:00')),
  AttendanceRecord('Jasmine Lau', '0162879190', DateTime.parse('2020-08-01 12:10:05')),
  AttendanceRecord('Chan Saw Lin', '016783239', DateTime.parse('2020-08-23 11:59:05')),
];
