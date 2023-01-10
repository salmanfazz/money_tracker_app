import 'package:flutter/material.dart';
import 'package:money_tracker_app/pages/add_transaction.dart';
import 'package:money_tracker_app/pages/signup_page.dart';
import 'package:money_tracker_app/pages/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  bool _isLoading = true;

  Future<List<dynamic>> getData() async {
    final res = await client
        .from('tracker')
        .select('*')
        .eq('user_id', client.auth.currentUser!.id)
        .order('id');
    return res;
  }

  Future<void> editData({
    required final id,
    required final amount,
    required final date,
    required final note,
  }) async {
    final res = await client
        .from('tracker')
        .update({'amount': amount, 'date': date, 'note': note}).eq('id', id);

    return res;
  }

  Future<void> deleteData({
    required final id,
  }) async {
    try {
      await client.from('tracker').delete().eq('id', id);
    } on AuthException catch (error) {
      context.showSnackBar(error.message);
    }
  }

  Future<void> initList() async {
    List<dynamic> value = await getData();

    for (var element in value) {
      data.add(element);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Money Tracker'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ConstrainedBox(
        constraints: const BoxConstraints(),
        child: data.isEmpty
            ? const Center(
          child: Text('No Data Available'),
        )
            : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              leading: const Icon(Icons.dataset),
              title: Text(
                data[index]['amount'],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Colors.lightBlue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
    );
  }
}
