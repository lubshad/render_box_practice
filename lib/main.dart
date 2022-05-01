import 'package:flutter/material.dart';
import 'package:render_object/custom_box.dart';
import 'package:render_object/custom_column.dart';
import 'package:render_object/custom_spacer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CustomColumn(
          children: const [
            CustomExpanded(
              flex: 1,
              child: SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "A Defenitive guide to\n" "render objects in flutter",
                style: TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Created by creativecreator",
                textAlign: TextAlign.center,
              ),
            ),
            CustomBox(flex: 5, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
