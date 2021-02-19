import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Smart Chat"),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                  child: Container(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Logout"),
                  ],
                ),
              ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats/jlHzu9z97NFVTz6lZVCj/messages")
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (ctx, index) => Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(documents[index]['text']),
                    ));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("chats/jlHzu9z97NFVTz6lZVCj/messages")
              .add({'text': 'New dummy hardcoded value'});
        },
      ),
    );
  }
}
