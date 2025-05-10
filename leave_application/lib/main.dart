import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_application/home.dart';
import 'package:leave_application/leave.dart';
import 'package:leave_application/sign.dart';
import 'package:leave_application/utils/api.dart';
import 'package:leave_application/utils/utils.dart';


Widget car() {
  return SignPage();
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: car(),
      routes: {
        "/home": (context) => Home(),
        "/sign": (context) => SignPage(),
        "/Ad": (context) => Myapp(),
      },
    ),
  );
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => MyappState();
}

class MyappState extends State<Myapp> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List pending = [];
  List his = [];

  Future<void> _loadData() async {
    final response = await fetchLeaveList("getLeaveReq");
      setState(() {
        for (var element in response) {
          if (element['status'] == null) {
            pending.add(element);
          } else {
            his.add(element);
          }
        }
      }); 
  }

  int myIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      myIndex = index;
    });
  }

  Widget buildList(int currentIndex) {
    return ListView.builder(
      itemCount: currentIndex == 0 ? pending.length : his.length,
      itemBuilder: (context, index) {
        final item = currentIndex == 0 ? pending[index] : his[index];
        final start = item['from'];
        final end = item['to'];

        void _updateStatus(bool res) async  {
             updateStatus(context,item,res);
             setState(() {
              pending =[];
              his=[];
             });
          await  _loadData();
        }

        Widget trailing;
        if (currentIndex == 0) {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: FloatingActionButton(
                  onPressed: () {
                    _updateStatus(true);
                  },
                  backgroundColor: Colors.green,
                  heroTag: UniqueKey(),
                  child: Icon(Icons.check),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  _updateStatus(false);
                },
                backgroundColor: Colors.red,
                heroTag: UniqueKey(),
                child: Icon(Icons.close),
              ),
            ],
          );
        } else {
          bool status = item['status'] as bool;
          trailing = Text(
            status ? "Accepted" : "Rejected",
            style: TextStyle(
              color:
                  status ? const Color.fromARGB(255, 76, 226, 11) : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        }

        return Card(
          margin: EdgeInsets.all(12),
          child: ListTile(
            title: Text(
              item["name"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            subtitle: Text(
              "${item['reason']}\n"
              "From $start to $end"
              "no. days:${(DateFormat('dd/MM/yyyy').parse(start).difference(DateFormat('dd/MM/yyyy').parse(end)).inDays).abs()}",
              style: TextStyle(fontSize: 16),
            ),
            isThreeLine: true,
            trailing: trailing,
            onTap: () async {
              var res = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => Leavepage(
                        data: item,
                        index: currentIndex,
                        //
                      ),
                ),
              );
              if (res == true || res == false) {
                _updateStatus(res);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave requests"),
        backgroundColor: const Color.fromARGB(255, 47, 173, 232),
        automaticallyImplyLeading: false,
         actions: [
    IconButton(
      icon: Icon(Icons.logout_outlined),
      tooltip: 'Logout',
      onPressed: ()=>confirmLogout(context),
    ),
  ],
      ),
      body: RefreshIndicator(
        onRefresh: ()  async => setState(() {
           pending =[];
              his=[];
          _loadData();
        }),
        child: Column(
          children: [
            Text('Total Requests: ${pending.length}'),
            Expanded(child: buildList(myIndex)),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: myIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
