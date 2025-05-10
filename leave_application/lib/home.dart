import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:leave_application/utils/auth.dart';
import 'package:leave_application/utils/utils.dart';
import 'package:leave_application/utils/api.dart';


typedef LeaveItem =dynamic ;//Map<String, dynamic>;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<LeaveItem> pending = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await fetchLeaveList('getUserReq');
      setState(() {
        pending = data;
      });
    } catch (e) {
      log('Error loading data: $e');
    }
  }



  Future<void> _openForm() async {
    final result = await Navigator.of(context).push<LeaveItem>(
      MaterialPageRoute(builder: (_) => LeaveRequestForm()),
    );
    if (result != null) {
      setState(() {
        pending.add(result);
      });
    }
  }


  Widget _buildList() {
    final list =  pending;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final item = list[i];
        final start = item['from'] ;
        final end = item['to'] ;
          
        Widget trailing = Text(
          item['status']==null?'Pending':(item['status'] ? 'Accepted' :'Rejected'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item['status']==null? Colors.blue:(item['status'] ? Colors.green : Colors.red),
            fontSize: 18,
            ),
          );
        

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              item['name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${item['reason']}\nFrom $start to $end'
              ' (no. days:${(DateFormat('dd/MM/yyyy').parse(start)
      .difference(DateFormat('dd/MM/yyyy').parse(end)).inDays).abs()} )',
            ),
            isThreeLine: true,
            trailing: trailing,
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Details'),
                content: Text(item['body']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Application'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: _openForm,
              child: Icon(Icons.add),
            ),
    );
  }
}

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
   createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(TextEditingController ctrl, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        ctrl.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _submit() async{
    if (_formKey.currentState!.validate()) {
       final dateFormat = DateFormat('dd/MM/yyyy');
      final Map<String,String> data = {
        'reason': _reasonCtrl.text.trim(),
        'body': _bodyCtrl.text.trim(),
        'from': dateFormat.format(_startDate!).toString(),
        'to': dateFormat.format(_endDate!).toString(),
      };
    final uri = Uri.parse('http://10.0.2.2:3000/create');
    final Map<String,String> header  = await AuthService.instance.getToken();

    final res = await http.post(uri,body:data ,headers: header);
    final jsonRes = jsonDecode(res.body);
    log("$jsonRes");

     if(jsonRes["code"]==4 ){
      Navigator.pushNamed(context, "/sign");
      dialogBox(context,"Session expired",Colors.red,"Login again");
    }
   else if(res.statusCode!=201){
      dialogBox(context,"erorr",Colors.red,"falied to upload please reupload");
      return;
    }
      Navigator.pop(context);
       dialogBox(context,"successfully",Colors.green,"Request send successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Leave')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //from
              TextFormField(
                controller: _fromCtrl,
                readOnly: true,
                decoration: InputDecoration(labelText: 'From Date'),
                onTap: () => _pickDate(_fromCtrl, true),
                validator: (_) => _startDate == null ? 'Select date' : null,
              ),
              SizedBox(height: 12),
              //to date
              TextFormField(
                controller: _toCtrl,
                readOnly: true,
                decoration: InputDecoration(labelText: 'To Date'),
                onTap: () => _pickDate(_toCtrl, false),
                validator: (_) {
                  if (_endDate == null) return 'Select date';
                  if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                    return 'End before start';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _reasonCtrl,
                decoration: InputDecoration(labelText: 'Reason (≤50 words)'),
                maxLines: null,
                validator: (v) {
                  final count = v!.trim().split(RegExp(r'\s+')).length;
                  if (v.trim().isEmpty) return 'Enter reason';
                  if (count > 50) return 'Max 50 words (got \$count)';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _bodyCtrl,
                decoration: InputDecoration(labelText: 'Body'),
                maxLines: 5,
                validator: (v) => v!.trim().isEmpty ? 'Enter details' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
