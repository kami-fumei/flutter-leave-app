import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'auth.dart';
import 'package:http/http.dart ' as http;
import 'utils.dart';

void updateStatus(BuildContext context,item,bool res) async{
    final uri = Uri.parse('http://10.0.2.2:3000/updateStatus');
    log("car");
          final tokenheader = await AuthService.instance.getToken();
          final response = await http.post(
            uri,
            headers: tokenheader,
            // ignore: unnecessary_cast
            body: {"status": res.toString(), "_id": item["_id"].toString()} as Map<String,String>
          );

          if(response.statusCode==200){
            showMessage(context,"Successfully updated");
          }
          else{
             showMessage(context,"failed to update status");
          }
          }

  Future<List> fetchLeaveList(String route) async {
    // todo todo
    final uri = Uri.parse('http://10.0.2.2:3000/$route');
    final tokenheader = await AuthService.instance.getToken();
    final response = await http.get(uri,headers: tokenheader);

    if (response.statusCode == 200) {
      // final List<LeaveItem> data =
      return jsonDecode(response.body) ;
      // return data;
    } else {
      throw Exception('Failed to load leave list');
    }
  }
  
   Future<void> signup(BuildContext context,body) async {
    final uri = Uri.parse('http://10.0.2.2:3000/signup');

    final response = await http.post(uri, body: body);
    // log();
    final resJs = jsonDecode(response.body);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var mes = "Successfully created the user now can login";
        dialogBox(context, "Successful", Colors.green, mes);
      } 
      else {
        throw resJs['message'] ?? 'something';
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      dialogBox(context, "Error", Colors.red, e.toString());
    }
  }

 Future<void> login(BuildContext context,body) async {
    final uri = Uri.parse('http://10.0.2.2:3000/login');

    final response = await http.post(uri, body: (body));
    final resJs = jsonDecode(response.body);

   try {
      if (response.statusCode == 201) {
        // dialogBox(context, "Logined", Colors.green,"hi ${resJs["user"]["name"]}");
         await AuthService.instance.saveTokenFromResponse(response);

          if(resJs['isAdmin']==true){
            Navigator.pushNamed(context, '/Ad');
          }else{
             Navigator.pushNamed(context, '/home');
          }
         
      } 
      else {
        throw resJs['message'] ?? 'something went worng';
      }
    } catch (e) {

      // ignore: use_build_context_synchronously
      dialogBox(context, "Error", Colors.red, e.toString());
     
    }
  
  }