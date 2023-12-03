import 'package:flutter/material.dart';
import 'package:adaptive_stream/widgets/counter.dart';
import 'package:adaptive_stream/widgets/stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Stream Counter',
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final _counterStream = Counter();
  List<Stream> streamList = [];
  Streams newTask = Streams(0, "", false);

  @override
  void initState() {
    super.initState();
    _counterStream.startCounter(streamList);
  }

  void deleteTask(int index) {
    streamList.removeAt(index);
   // print('${streamList[0].titulo}');
  }

  @override
  void dispose() {
    _counterStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stream Counter"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder<List<Stream>>(
          stream: _counterStream.counterStream,
          builder: (context, snapshot) {
            streamList = snapshot.data!;
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: buildTaskListView(streamList.cast<Streams>()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showAddTaskDialog(context);
                      },
                      child: Text('Add Task'),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildTaskListView(List<Streams> taskList) {
    return Center(
      child: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildTaskListItem(taskList, index);
        },
      ),
    );
  }

  Widget buildTaskListItem(List<Streams> taskList, int index) {
    return ListTile(
      title: Row(
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text('${taskList[index].id}'),
            ),
          ),
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text(taskList[index].titulos),
            ),
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                taskList[index].estado ? 'Completed' : 'Pending',
                style: TextStyle(
                  color: taskList[index].estado ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          buildCloseButton(index),
          const SizedBox(width: 20),
          buildCheckButton(taskList, index),
        ],
      ),
    );
  }

  Widget buildCloseButton(int index) {
    return RawMaterialButton(
      onPressed: () {
        deleteTask(index);
        _counterStream.startCounter(streamList.cast<Stream>());
      },
      constraints: BoxConstraints.tightFor(
        width: 25,
        height: 25,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: Colors.red,
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  Widget buildCheckButton(List<Streams> taskList, int index) {
    return RawMaterialButton(
      onPressed: !taskList[index].estado
          ? () {
              taskList[index].estado = true;
              _counterStream.startCounter(taskList.cast<Stream>());
            }
          : null,
      constraints: BoxConstraints.tightFor(
        width: 25,
        height: 25,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: Colors.green,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  void showAddTaskDialog(BuildContext context) {
    String userInput = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Name your task'),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter text here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                newTask = Streams(
                  streamList.length + 1,
                  '$userInput',
                  false,
                );
                streamList.add(newTask as Stream);
                _counterStream.startCounter(streamList);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
