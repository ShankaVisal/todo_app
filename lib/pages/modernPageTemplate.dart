import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/pages/aboutpage.dart';
import 'package:todo_app/pages/contactuspage.dart';
import 'package:todo_app/pages/helppage.dart';
import 'package:todo_app/pages/homapage.dart';
import 'package:todo_app/pages/settingspage.dart';
import 'package:todo_app/pages/new_todo_task_page.dart';

class ModernPageTemplate extends StatefulWidget {
  final String title;
  final Widget bodyContent;

  ModernPageTemplate({super.key, required this.title, required this.bodyContent});

  @override
  State<ModernPageTemplate> createState() => _ModernPageTemplateState();
}

class _ModernPageTemplateState extends State<ModernPageTemplate> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
       _searchFocusNode.dispose(); // <-- dispose properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: _buildDrawer(context),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1A1A1A),
              Color(0xFF0F0F0F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Stack like home page
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(221, 255, 255, 255),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 4,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white70, size: 28),
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Page-specific content
              Expanded(child: widget.bodyContent),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Doneo", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Get it done... simply.", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          ),
          _drawerItem(Icons.home, "Tasks", (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ModernHomePage()));
          }),
          _drawerItem(Icons.info, "About", () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AboutPage()));
          }),
          _drawerItem(Icons.contact_mail, "Contact Us", () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ContactUsPage()));
          }),
          _drawerItem(Icons.help, "Help", () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => HelpPage()));
          }),
          _drawerItem(Icons.settings, "Settings", () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
          }),
          Divider(color: Colors.white54),
          _drawerItem(Icons.exit_to_app, "Exit", () {
            Navigator.pop(context);
            Future.delayed(Duration(milliseconds: 200), () {
              SystemNavigator.pop();
            });
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
