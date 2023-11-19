import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_SettingsScreenState.dart';
import 'usernameinput.dart';
import 'goalscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum ActiveTab { home, goals, tasks, settings }

class _HomeScreenState extends State<HomeScreen> {
  ActiveTab _activeTab = ActiveTab.home; // Default active tab

  String userName = '';
  String wakeUpTime = '';
  String bedTime = '';

  Widget _getScreenContent() {
    switch (_activeTab) {
      case ActiveTab.home:
        return _buildHomeScreen();
      case ActiveTab.goals:
        return const GoalsScreen();
      case ActiveTab.tasks:
        return const HomePage();
      case ActiveTab.settings:
        return SettingsScreen(
          userName: userName,
          onUserDataChanged: _updateUserData,
        );
      default:
        return const Center(child: Text('Unknown Tab'));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopBox(),
          _buildCardWithTitleAndImage(
              "Working out", "assets/squat.jpeg"), // Placeholder for your image
          // Add more cards as needed
        ],
      ),
    );
  }

  Widget _buildTopBox() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        "$userName 2.0 is working now. Are you?",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCardWithTitleAndImage(String title, String imagePath) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // If you want to add more details like subtitle, you can add here
          ),
          Container(
            height: 400, // Fixed height for the image
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Add more content to the card if needed
        ],
      ),
    );
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInfoAvailable = prefs.getString('userName') != null;

    if (!isInfoAvailable) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserNameInput(
            onSubmit: (String name, String wakeTime, String sleepTime) {
              _setUserData(name, wakeTime, sleepTime);
            },
          ),
        ),
      );
    } else {
      // Load user data into the state
      setState(() {
        userName = prefs.getString('userName') ?? '';
        wakeUpTime = prefs.getString('wakeUpTime') ?? '';
        bedTime = prefs.getString('bedTime') ?? '';
      });
    }
  }

  void _setUserData(String name, String wakeTime, String sleepTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('wakeUpTime', wakeTime);
    await prefs.setString('bedTime', sleepTime);

    setState(() {
      userName = name;
      wakeUpTime = wakeTime;
      bedTime = sleepTime;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _updateUserData(String name, String wakeTime, String sleepTime) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userName', name);
      prefs.setString('wakeUpTime', wakeTime);
      prefs.setString('bedTime', sleepTime);
    });

    setState(() {
      userName = name;
      wakeUpTime = wakeTime;
      bedTime = sleepTime;
    });
  }

  ListTile _buildDrawerItem(IconData icon, String title, ActiveTab tab) {
    bool isActive = _activeTab == tab;

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.black),
      title: Text(title,
          style: TextStyle(color: isActive ? Colors.blue : Colors.black)),
      onTap: () {
        setState(() {
          _activeTab = tab;
        });
        Navigator.pop(context);
      },
    );
  }

  String _getAppBarTitle() {
    switch (_activeTab) {
      case ActiveTab.home:
        {
          return 'Home';
          //return outputfrombox().toString();
        }

      case ActiveTab.goals:
        return 'Goals';
      case ActiveTab.settings:
        return 'Settings';
      case ActiveTab.tasks:
        return 'Tasks';
      default:
        return 'EneMe Home'; // Default title
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Welcome, $userName'),
              accountEmail: const Text("You have to catch up"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 171, 179, 233),
                child: Text(
                  userName.isNotEmpty ? userName[0] : 'U',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', ActiveTab.home),
            _buildDrawerItem(Icons.flag, 'Goals', ActiveTab.goals),
            _buildDrawerItem(Icons.checklist, 'Tasks', ActiveTab.tasks),
            _buildDrawerItem(Icons.settings, 'Settings', ActiveTab.settings),
            // More items...
          ],
        ),
      ),
      body: _getScreenContent(),
    );
  }
}
