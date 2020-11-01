import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          "Contacts",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MyName(),
            MyID(),
            FriendList(),
          ],
        ),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class MyName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: "Jeremy",
        enabled: false,
        decoration: InputDecoration(
          labelText: "My Name:",
          labelStyle: TextStyle(
            color: kTextColor,
            fontSize: 20.0,
          ),
          filled: true,
          fillColor: kSecondaryColor,
        ),
        style: TextStyle(
          color: kTextColor,
          fontSize: 22.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
    );
  }
}

class MyID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: "#70425",
        enabled: false,
        decoration: InputDecoration(
          labelText: "My ID:",
          labelStyle: TextStyle(
            color: kTextColor,
            fontSize: 20.0,
          ),
          filled: true,
          fillColor: kSecondaryColor,
        ),
        style: TextStyle(
          color: kTextColor,
          fontSize: 22.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
    );
  }
}

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<String> friendsname = [
    'Chris',
    'KrasserChris',
    'Chris',
    'KrasserChris',
    'Chris',
    'KrasserChris',
    'Chris',
    'KrasserChris',
    'Chris',
    'KrasserChris',
  ];
// List<String> friendsid = ['#32423', '#2342','Chris', 'KrasserChris','Chris', 'KrasserChris','Chris', 'KrasserChris','Chris', 'KrasserChris',];
  void addFriend(String friend) {
    setState(() {
      friendsname.add(friend);
    });
  }
  void deleteFriend(int index){
    setState(() {
      friendsname.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          child: TextField(
            onSubmitted: addFriend,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Add Friend"),
          ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: friendsname.length,
              itemBuilder: (context, i) {
                return Friend(friendsname[i], () { deleteFriend(i);});

              }),
        ),
      ],
    );
  }
}

class Friend extends StatelessWidget {
  final String friendName;
  final Function remove;
  const Friend(this.friendName, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
        title: Text(
          friendName,
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever_rounded),
          color: Colors.white,
          iconSize: 28.0,
          onPressed: () { remove();},
        ),
      ),
    );
  }
}
