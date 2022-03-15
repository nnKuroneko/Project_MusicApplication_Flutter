import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

}

class UploadScreen extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ทดสอบ CRUD firebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

    final CollectionReference schedules = FirebaseFirestore.instance.collection('playlist');

    Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {

      String action = 'create';
      if (documentSnapshot != null) {
        action = 'update';
        _titleController.text = documentSnapshot['name'];
        _descriptionController.text = documentSnapshot['singer'];

        await showModalBottomSheet(
            isScrollControlled: true ,
            context: context,
            builder: (BuildContext ctx){
              return Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom +20
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'ชื่อวิชา'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'ชื่อวิชา'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text(action == 'create' ? 'Create' : 'Update' ),
                      onPressed: () async {
                        final String? title = _titleController.text;
                        final String? description = _descriptionController.text;

                        if (title != null && description != null){
                          if (action == 'create'){
                            await schedules.add({"name": title, "singer": description});
                          }

                          if(action == 'update') {

                            await schedules
                                .doc(documentSnapshot.id)
                                .update({"name": title, "singer": description});
                          }

                          _titleController.text = '';
                          _descriptionController.text = '';

                          Navigator.of(context).pop();

                        }

                      },

                    )

                  ],

                ),

              );

            });

      }

    }

    Future<void> _deleteProduct(String productId) async {
      await schedules.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ทำการลบรายการเรียบร้อย')));

    }


    return Scaffold(
      appBar: AppBar(

        title: const Text('ทดสอบการ CRUD Firestore'),
      ),
      body: StreamBuilder(

        stream: schedules.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){

          if (streamSnapshot.hasData){



            return ListView.builder(

              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context,index) {

                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(

                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name'].toString()),
                    subtitle: Text(documentSnapshot['singer'].toString()),

                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),

                        ],
                      ),
                    ),
                  ),
                );
              },
            );



          }


          return const Center(
            child: CircularProgressIndicator(),

          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
