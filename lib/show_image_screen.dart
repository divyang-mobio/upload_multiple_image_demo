import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'firebase_calling.dart';

class ShowImagePage extends StatefulWidget {
  const ShowImagePage({Key? key}) : super(key: key);

  @override
  State<ShowImagePage> createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Show Images')),
      body: FutureBuilder(
        future: FirebaseCalling.listAll('images/'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.length == 0) {
              return Center(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No image found pls upload.')));
            } else {
              return GridView.builder(
                  itemCount: snapshot.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return Stack(children: [
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Image.network(
                              (snapshot.data?[index]).toString(),
                              fit: BoxFit.fill)),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () => FirebaseStorage.instance
                                    .refFromURL(
                                        (snapshot.data?[index]).toString())
                                    .delete()
                                    .whenComplete(() {
                                  setState(() {});
                                  return;
                                }),
                            icon: const Icon(Icons.cancel),
                            color: Colors.red),
                      )
                    ]);
                  });
            }
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
