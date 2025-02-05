import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/theme_logic.dart';

class DartMode extends StatefulWidget {
  const DartMode({super.key});

  @override
  State<DartMode> createState() => _DartModeState();
}

class _DartModeState extends State<DartMode> {
  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.watch<ThemeLogic>().mode;
    return Scaffold(
        appBar: AppBar(
          title: Text('Dart Mode'),
        ),
        body: Column(
          children: [
            ExpansionTile(
              title: Text("Changes Theme Settings"),
              initiallyExpanded: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: Text("Light Mode"),
                  onTap: () {
                    context.read<ThemeLogic>().changeToLight();
                  },
                  trailing:
                      mode == ThemeMode.light ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text("Dark Mode"),
                  onTap: () {
                    context.read<ThemeLogic>().changeToDark();
                  },
                  trailing:
                      mode == ThemeMode.dark ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text("System"),
                  onTap: () {
                    context.read<ThemeLogic>().changeSystem();
                  },
                  trailing:
                      mode == ThemeMode.system ? const Icon(Icons.check) : null,
                ),
              ],
            ),
          ],
        ));
  }
}
