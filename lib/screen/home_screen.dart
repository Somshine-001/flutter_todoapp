import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String API_URL = 'http://127.0.0.1:5001/todos';
  List todoList = [];

  Future<List> fetchtodoList() async {
    final response = await http.get(Uri.parse(API_URL));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    fetchtodoList();
    // TODO: implement initState
    super.initState();
    fetchtodoList().then((value) {
      setState(() {
        todoList = value;
      });
    });
  }

  final task = TextEditingController();

  Future<void> createTodo() async {
    final response = await http.post(
      Uri.parse(API_URL),
      headers: {'Content-Type': 'application/json'},
      body: {Title: task.text},
    );
  }

  void addTodo() {
    setState(() {
      todoList.add(task.value.text);
      task.clear();
    });
  }

  void deleteTodo(index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ที่ต้องทำ',
                    ),
                    keyboardType: TextInputType.text,
                    controller: task,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: addTodo,
                    child: const Text('เพิ่ม'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todoList[index]["title"]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteTodo(index),
                    ),
                  );
                },
                itemCount: todoList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
