import 'package:firebase_realtiime_database/provider/crud_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../screens/add_new_user_screen.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CRUDOperationsProvider>(context);
    return Card(
      child: ListTile(
        title: Text(user.userName),
        subtitle: Text(user.email),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddNewUserScreen(user: user)));
        },
        trailing: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AddNewUserScreen(user: user)));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    provider.deleteUserData(id:user.docId, context: context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        ),
      ),
    );

  }
}
