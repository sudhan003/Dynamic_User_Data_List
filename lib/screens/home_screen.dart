import 'package:firebase_realtiime_database/provider/crud_operations_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/user_tile.dart';
import '../widgets/uses_tile.dart';
import 'add_new_user_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CRUDOperationsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore CRUD Operation"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddNewUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchUsers(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return UserTile(user:provider.list[index]);
            },
            itemCount: provider.list.length,
          ),
        ),
      ),
    );
  }
}
