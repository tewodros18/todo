import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/todos/bloc/todo_bloc.dart';
import 'package:todo/todos/data_provider/todo_dataprovider.dart';
import 'package:todo/todos/models/todo_model.dart';
import 'package:todo/todos/repository/todo_repository.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Website todo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TodoRepository _todoRepository =
      TodoRepository(todoDataProvider: TodoDataProvider());
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  bool newTask = true;
  bool addForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 25, 2),
        child: RepositoryProvider.value(
          value: _todoRepository,
          child: BlocProvider(
              create: (context) => TodoBloc(todoRepository: _todoRepository)
                ..add(LoadTodosEvent()),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child:
                    BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
                  if (state is TodosLoadingFailedState) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                      child: Center(
                        child: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.replay),
                          onPressed: () {
                            context.read<TodoBloc>().add(LoadTodosEvent());
                          },
                        ),
                      ),
                    );
                  }
                  if (state is TodosLoadedState) {
                    List<dynamic> _allTodos = state.todoList;
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 500,
                            width: 500,
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    todoCard(allTodos: _allTodos[index]),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                          width: 15,
                                        ),
                                itemCount: state.todoList.length),
                          ),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: addForm,
                              child: Form(
                                key: _formKey,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          hintText: 'Content',
                                        ),
                                        controller: myController,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 150.0, top: 40.0),
                                        child: Row(
                                          children: [
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 3,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  addForm = !addForm;
                                                  newTask = true;
                                                });
                                              },
                                              icon: const Icon(Icons.close),
                                              label: const Text("Cancel"),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 3,
                                              ),
                                              onPressed: () {
                                                if (myController.text != "") {
                                                  var todo = Todo(
                                                      content:
                                                          myController.text,
                                                      created: Timestamp.now(),
                                                      updated: Timestamp.now(),
                                                      done: false);
                                                  setState(() {
                                                    addForm = !addForm;
                                                    newTask = true;
                                                    context
                                                        .read<TodoBloc>()
                                                        .add(CreateTodoEvent(
                                                            collection: "todos",
                                                            data:
                                                                todo.toMap()));
                                                  });
                                                }
                                              },
                                              icon: const Icon(Icons.add),
                                              label: const Text("Create"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: newTask,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width / 4,
                                      60),
                                ),
                                onPressed: () {
                                  setState(() {
                                    newTask = false;
                                    addForm = !addForm;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("New Task"),
                              )),
                        ],
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
              )),
        ),
      ),
    );
  }
}

class todoCard extends StatefulWidget {
  todoCard({
    Key? key,
    required allTodos,
  })  : _aTodo = allTodos,
        super(key: key);

  final _aTodo;

  @override
  State<todoCard> createState() => _todoCardState(_aTodo);
}

class _todoCardState extends State<todoCard> {
  final aTodo;
  late bool isChecked;
  _todoCardState(this.aTodo) {
    isChecked = aTodo.data()["Done"];
  }
  bool editMode = false;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        children: [
          Visibility(
            maintainSize: false,
            maintainAnimation: true,
            maintainState: true,
            visible: !editMode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget._aTodo.data()["Done"]
                    ? Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                            color: Colors.purple, shape: BoxShape.circle),
                      )
                    : Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                const SizedBox(
                  width: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: widget._aTodo.data()["Content"],
                    style: TextStyle(
                      color: Colors.grey[700],
                      decoration: widget._aTodo.data()["Done"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                ),
                Spacer(),
                widget._aTodo.data()["Done"]
                    ? IconButton(
                        onPressed: () {
                          context
                              .read<TodoBloc>()
                              .add(deleteTodoEvent("todos", widget._aTodo.id));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                    : Container(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        editMode = !editMode;
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
          Visibility(
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              visible: editMode,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Content',
                      ),
                      controller: myController,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.green,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = !isChecked;
                        print(isChecked);
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    onPressed: () {
                      setState(() {
                        var data = {
                          "Done": isChecked,
                          "Updated": Timestamp.now()
                        };
                        if (myController.text != "") {
                          data["Content"] = myController.text;
                        }
                        context.read<TodoBloc>().add(
                            updateTodoEvent("todos", widget._aTodo.id, data));
                      });
                    },
                    child: const Icon(Icons.check),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    onPressed: () {
                      setState(() {
                        editMode = !editMode;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
