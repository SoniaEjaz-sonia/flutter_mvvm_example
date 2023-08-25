import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight.withAlpha(80),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                        controller: _inputController,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {}
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter Artist Name',
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
