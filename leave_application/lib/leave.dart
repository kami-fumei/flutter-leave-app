import 'package:flutter/material.dart';

class Leavepage extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  // final Function(bool)? onDecision;
  const Leavepage({super.key, required this.data, required this.index,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Leave Details')),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
            Text(data['name'],style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
             Text('Reason:', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
            Text(data['reason'], style: TextStyle(fontSize:18 )),
            SizedBox(height: 12),
            Text('Body:', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
            Text(data['body'], style: TextStyle(fontSize:18 )),
            SizedBox(height: 12),
            Text('From:', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
            Text((data['from']), style: TextStyle(fontSize:18 )),
            SizedBox(height: 8),
            Text('To:', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
            Text((data['to']), style: TextStyle(fontSize:18 )),
            SizedBox(height: 8),
          ]
        )
        ),
     floatingActionButton: index==0?
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () { 
            Navigator.pop(context,true);
            },
            heroTag: UniqueKey(),
            child: Icon(Icons.done),
          ),
          FloatingActionButton(onPressed: () {
           Navigator.pop(context,false);
            },
            heroTag: UniqueKey(), 
            child: Icon(Icons.close),)
        ],
      )
      :FloatingActionButton(onPressed: (){},child: Text("car",style :TextStyle(color: Colors.amberAccent ),) )
    );
  }
}
