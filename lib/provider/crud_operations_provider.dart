import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_realtiime_database/model/user.dart';

class CRUDOperationsProvider extends ChangeNotifier {
  CRUDOperationsProvider(){
    fetchUsers();
  }
  late List<User> list;

  fetchUsers() async {
    list = [];
    final response = await http.get(Uri.parse(
        "https://fireservice-003-default-rtdb.europe-west1.firebasedatabase.app/users.json"));
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
      list.add(User(
          email: value["email"],
          phoneNumber: value["phone_Number"],
          userName: value["name"],
          docId: key));
    });
    notifyListeners();
    print(response.body);
  }

  final formKey = GlobalKey<FormState>();
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  sendUserOnFirebase(BuildContext context) async {
    isLoading = true;

    // try{
    final response = await http.post(
        Uri.parse(
            "https://fireservice-003-default-rtdb.europe-west1.firebasedatabase.app/users.json"),
        body: jsonEncode({
          "name": usernameController.text,
          "email": emailController.text,
          "phone_Number": phoneNumberController.text
        }));
    notifyListeners();
    print(response.statusCode);
    //send user

    if (response.statusCode == 200) {
      usernameController = TextEditingController();
      emailController = TextEditingController();
      phoneNumberController = TextEditingController();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Data added",
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }

    isLoading = false;

    // print(response.id);
  }

  updateUser({required String id, required BuildContext context}) async {
    //update user

    final response = await http.patch(
        Uri.parse(
            "https://fireservice-003-default-rtdb.europe-west1.firebasedatabase.app/users/${id}.json"),
        body: jsonEncode({
          "name": usernameController.text,
          "email": emailController.text,
          "phone_Number": phoneNumberController.text
        }));
    notifyListeners();
    print(response.statusCode);
    if (response.statusCode == 200) {
      usernameController = TextEditingController();
      emailController = TextEditingController();
      phoneNumberController = TextEditingController();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Data updated",
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }
  }

  deleteUserData({required String id, required BuildContext context}) async {
    final response = await http.delete(Uri.parse(
        "https://fireservice-003-default-rtdb.europe-west1.firebasedatabase.app/users/${id}.json"));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Data deleted",
        ),
        backgroundColor: Colors.green,
      ));
      fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }

  }
}
