import 'dart:math';

import 'package:flutter/material.dart';
import 'package:render_object/custom_box.dart';
import 'package:render_object/custom_column.dart';
import 'package:render_object/custom_spacer.dart';

import 'custom_proxy_box.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            CustomColumn(
              alignment: CustomColumnAlignment.end,
              children: [
                const CustomExpanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "A Defenitive guide to\n" "render objects in flutter",
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Created by creativecreator",
                    textAlign: TextAlign.center,
                  ),
                ),
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomBox(
                          onTap: () {
                            if (_controller.isAnimating) {
                              _controller.stop();
                            } else {
                              _controller.repeat();
                            }
                          },
                          flex: 1,
                          color: Colors.blue,
                          rotation: _controller.value * 2 * pi);
                    }),
              ],
            ),
            CustomProxyBox(
              child: Container(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
