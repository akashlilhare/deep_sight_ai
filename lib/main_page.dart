import 'package:deep_sight_ai_labs/pages/dashboard_page/home_page.dart';
import 'package:deep_sight_ai_labs/pages/report_page/report_page.dart';
import 'package:deep_sight_ai_labs/pages/settings_page/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final int? initialPage;

  static const routeName = "main-page";

  const MainPage({Key? key, this.initialPage}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.initialPage ?? 0;
    super.initState();
  }

  onBack() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              iconTheme: MaterialStateProperty.all(
                  IconThemeData(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.7))),
              labelTextStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                  )),
              indicatorColor: Theme.of(context).primaryColor.withOpacity(.3)),
          child: NavigationBar(
            height: 70,
            elevation: 5,
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 24,
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    size: 22,
                  ),
                  label: "Dashboard"),

              NavigationDestination(
                  icon: Icon(
                    Icons.insert_chart_outlined,
                    size: 24,
                  ),
                  selectedIcon: Icon(
                    Icons.insert_chart_rounded,
                    size: 24,
                  ),
                  label: "Report"),
              NavigationDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 24,
                  ),
                  selectedIcon: Icon(
                    Icons.settings,
                    size: 24,
                  ),
                  label: "Settings"),
            ],
          ),
        ),
        body: getIndex());
  }

  getIndex() {
    if (currentIndex == 0) {
      return HomePage();
    } else if (currentIndex == 1) {
      return ReportPage();
    } else if (currentIndex == 2) {
      return SettingsPage();
    } else {
      return Container();
    }
  }
}
