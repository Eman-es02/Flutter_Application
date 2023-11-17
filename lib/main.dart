import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async';


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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppState()),
      ],
      child: MaterialApp(
        title: 'Attendance',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: const OnBoardingScreen(), // Start with the onboarding screen
      ),
    );
  }
}

class OnBoard {
  final String image1, image2, description;

  OnBoard({
    required this.image1,
    required this.image2,
    required this.description,
  });
}

final List<OnBoard> onBoardingData = [
  OnBoard(
    image1: "assets/img1.png",
    image2: "assets/img2.png",
    description: "Welcome to our app!\n\n Here's how to use our app features:\n\n 1. Changing date format  ",
  ),
  OnBoard(
    image1: "assets/img3.png",
    image2: "assets/img4.png",
    description: "2. How to add a new record",
  ),
  OnBoard(
    image1: "assets/img5.png",
    image2: "assets/img6.png",
    description: "3. Record added successfully\n\n Get started and enjoy our app!",
  ),
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 2) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        currentPage++;
      });
    } else {
      // Navigate to the home page when the last page is reached
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyHomePage()),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: onBoardingData.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.purple, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          onBoardingData[index].image1,
                          height: 300,
                          width: 300,
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          onBoardingData[index].image2,
                          height: 200,
                          width: 200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onBoardingData[index].description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
	        //next button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: nextPage,
                child: Text(currentPage < 2 ? 'Next' : 'Finish'),
              ),
            ),
          ),
        ],
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
        page = AddRecordScreen();
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
          Expanded( 
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


class RecordList extends StatefulWidget {
  final bool isDateFormatChanged;

  RecordList({required this.isDateFormatChanged});

  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  final ScrollController _scrollController = ScrollController();
  bool showEndOfListMessage = false;
  final JsonFileManager jsonFileManager = JsonFileManager('assets/Attendance_Dataset.json');


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      // Scrolling down
      if (showEndOfListMessage) {
        setState(() {
          showEndOfListMessage = false;
        });
      }
    }

    if (!showEndOfListMessage &&
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Scrolling up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have reached the end of the list'),
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {
        showEndOfListMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context, listen: true);
    final List<Map<String, dynamic>> jsonRecords = jsonFileManager.loadJsonData();

    List<AttendanceRecord> filteredRecords = appState.searchKeyword.isEmpty
        ? jsonRecords.map((jsonRecord) {
            return AttendanceRecord.fromJson(jsonRecord);
          }).toList()
        : jsonRecords
            .where((jsonRecord) =>
                jsonRecord['user'].toLowerCase().contains(appState.searchKeyword.toLowerCase()) ||
                jsonRecord['phone'].contains(appState.searchKeyword))
            .map((jsonRecord) {
            return AttendanceRecord.fromJson(jsonRecord);
          })
            .toList();
            
    // Sort the filteredRecords based on check-in date
    filteredRecords.sort(AttendanceRecord.compareByCheckIn);

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        final checkIn = widget.isDateFormatChanged
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

class JsonFileManager {
  final String filePath;

  JsonFileManager(this.filePath);

  List<Map<String, dynamic>> loadJsonData() {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final jsonData = json.decode(file.readAsStringSync());
        if (jsonData is List) {
          return List<Map<String, dynamic>>.from(jsonData);
        }
      }
    } catch (e) {
      print("Error loading JSON data: $e");
    }
    return [];
  }

  void saveToJson(List<Map<String, dynamic>> data) {
    try {
      final file = File(filePath);
      file.writeAsStringSync(json.encode(data));
    } catch (e) {
      print("Error saving JSON data: $e");
    }
  }

  void addRecord(Map<String, dynamic> record) {
    final List<Map<String, dynamic>> existingData = loadJsonData();
    existingData.add(record);
    saveToJson(existingData);
  }
}


class AddRecordScreen extends StatelessWidget {
  final JsonFileManager jsonFileManager = JsonFileManager('assets/Attendance_Dataset.json');
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Record"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'User'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a user';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final newRecord = AttendanceRecord(
                      _userController.text,
                      _phoneController.text,
                      DateTime.now(),
                    );

                    // Add record to JSON file
                    jsonFileManager.addRecord({
                      'user': newRecord.user,
                      'phone': newRecord.phone,
                      'checkIn': newRecord.checkIn.toIso8601String(),
                    });

                    // Show a SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Record added successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    await Future.delayed(Duration(seconds: 2));

                    // Navigate back to the home page
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class AttendanceRecord {
  final String user;
  final String phone;
  final DateTime checkIn;
  AttendanceRecord(this.user, this.phone, this.checkIn);

    // Factory constructor to convert a Map<String, dynamic> to an AttendanceRecord instance
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
  final checkInString = json['check-in'] as String?;
  DateTime parsedCheckIn;

  if (checkInString != null) {
    try {
      parsedCheckIn = DateTime.parse(checkInString);
    } catch (e) {
      print("Error parsing 'check-in' value: $checkInString");
      parsedCheckIn = DateTime.now();
    }
  } else {
    parsedCheckIn = DateTime.now();
  }

  print("Parsed 'check-in' value: $parsedCheckIn");

  return AttendanceRecord(
    json['user'] as String,
    json['phone'] as String,
    parsedCheckIn,
  );
}

  // Method to convert the AttendanceRecord instance to a Map<String, dynamic>
    Map<String, dynamic> toJson() {
    return {
      'user': user,
      'phone': phone,
      'checkIn': checkIn.toIso8601String(),
    };
  }

  // Compare records based on the check-in date for sorting
  static int compareByCheckIn(AttendanceRecord a, AttendanceRecord b) {
    return b.checkIn.compareTo(a.checkIn);
}
}

