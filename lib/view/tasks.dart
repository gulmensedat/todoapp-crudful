import 'dart:async';
import 'dart:convert';

import 'package:crudfulapp/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

const cfAccessKey = 'cfAccessKey';
const key = '74181805d025cff76b107b58145834c248a8fe42';
const url = 'https://todo.crudful.com/tasks';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Future<Null> refresh() async {
    Future.delayed(Duration(milliseconds: 1));
    setState(() {});
    return null;
  }

  //tasks get, post, delete, patch

  Future<List<TaskModel>> getTasks() async {
    final response = await http.get('$url?isCompleted=true', headers: {
      "Content-Type": "application/json",
      cfAccessKey: key,
    });

    if (response.statusCode == 200) {
      String responseBodyBytes = utf8.decode(response.bodyBytes);
      Map<String, dynamic> taskMap = json.decode(responseBodyBytes);
      List<dynamic> data = taskMap['results'];

      List<TaskModel> tasks = [];

      for (var u in data) {
        TaskModel taskmodel = TaskModel(
          u['id'],
          u['createdAt'],
          u['title'],
          u['details'],
          u['due'],
          u['isCompleted'],
        );

        tasks.add(taskmodel);
      }

      print(data);
      return tasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<bool> createTask(String title) async {
    final response = await http.post('$url',
        headers: <String, String>{
          "Content-Type": "application/json",
          cfAccessKey: key,
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'isCompleted': true,
        }));

    if (response.statusCode == 201) {
      print('post success');
      return true;
    } else if (response.statusCode == 400) {
      print('post error');
      return false;
    } else {
      throw Exception('Failed create');
    }
  }

  Future<bool> deleteTask(String id) async {
    final response = await http.delete('$url/${id}', headers: {
      "Content-Type": "application/json",
      cfAccessKey: key,
    });

    if (response.statusCode == 204) {
      print('Delete success $id');
      return true;
    } else {
      print('delete error');
      return false;
    }
  }

  Future<bool> updateTask(String id, String title) async {
    final response = await http.patch('$url/$id',
        headers: {
          "Content-Type": "application/json",
          cfAccessKey: key,
        },
        body:
            jsonEncode(<String, dynamic>{'title': title, 'isCompleted': true}));

    if (response.statusCode == 200) {
      print('patch success');
      return true;
    } else if (response.statusCode == 400) {
      print('patch error');
      return false;
    } else {
      throw Exception('path error 2');
    }
  }

  //dialogs

  Future<void> createDialog() async {
    createController.clear();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create Task'),
            content: SingleChildScrollView(
                child: Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: createController,
                    validator: (val) {
                      if (val.isEmpty == true) {
                        print('empty');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                      focusColor: Colors.grey.withOpacity(0.3),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                ],
              ),
            )),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Create'),
                onPressed: () async {
                  bool create = await createTask(createController.text);
                  if (create == true) {
                    print('create success');
                    refresh();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  Future<void> deleteDialog(String id, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create Task'),
            content: SingleChildScrollView(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  bool delete = await deleteTask(id);
                  if (delete == true) {
                    print('delete success');
                    refresh();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  Future<void> updateDialog(String id, String title) async {
    updateController.text = title;
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Task'),
            content: SingleChildScrollView(
                child: Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: updateController,
                    validator: (val) {
                      if (val.isEmpty == true) {
                        print('empty');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                      filled: true,
                      fillColor: Colors.blue.withOpacity(0.3),
                      focusColor: Colors.blue.withOpacity(0.3),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                ],
              ),
            )),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Update'),
                onPressed: () async {
                  bool update = await updateTask(id, updateController.text);
                  if (update == true) {
                    print('update success');
                    refresh();
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  TextEditingController createController;
  TextEditingController updateController;

  @override
  void initState() {
    super.initState();
    createController = TextEditingController();
    updateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 70),

          //for appbar
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        refresh();
                      },
                      child: Icon(Icons.refresh, color: Colors.black)),
                  Text(
                    'Tasks',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                      onTap: () => createDialog(),
                      child: Icon(Icons.add, color: Colors.black)),
                ],
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: getTasks(),
              builder: (context, taskSnap) {
                if (taskSnap.hasData) {
                  return ListView.builder(
                    itemCount: taskSnap.data.length,
                    itemBuilder: (context, index) {
                      var taskIndex = taskSnap.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                child: Text(
                                    (taskSnap.data.length - index).toString()),
                                foregroundColor: Colors.white,
                              ),
                              title: Text(taskIndex.title),
                            ),
                          ),
                          actions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.blue,
                              icon: Icons.archive,
                              onTap: () =>
                                  updateDialog(taskIndex.id, taskIndex.title),
                            ),
                          ],
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () =>
                                  deleteDialog(taskIndex.id, taskIndex.title),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (taskSnap.hasError) {
                  print(taskSnap.hasError);
                  print(taskSnap.error);
                  return Text('');
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
