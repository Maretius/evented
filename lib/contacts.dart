import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'constants.dart';
import 'database.dart';

class Contacts extends StatelessWidget {
  final String userID;
  final String userToken;
  final String userName;
  final Map<String, String> userFriends;
  const Contacts(this.userID, this.userToken, this.userName, this.userFriends);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text("Contacts", style: TextStyle(fontSize: 24.0, fontFamily: 'SourceSansPro')),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MyName(userName),
            MyID(userToken),
            FriendList(userID, userFriends),
          ],
        ),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class MyName extends StatelessWidget {
  final String userName;
  const MyName(this.userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: userName,
        enabled: false,
        decoration: InputDecoration(
          labelText: "My Name:",
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          filled: true,
          fillColor: kPrimaryColor,
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
    );
  }
}

class MyID extends StatelessWidget {
  final String userToken;
  const MyID(this.userToken);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final RenderBox box = context.findRenderObject();
        Share.share("Hey here is my evented friendship token:\n\n$userToken", sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
      child: Container(
        child: TextFormField(
          initialValue: userToken,
          enabled: false,
          decoration: InputDecoration(
            labelText: "My Token:",
            labelStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'SourceSansPro'),
            filled: true,
            fillColor: kPrimaryColor,
          ),
          style: TextStyle(color: Colors.white, fontSize: 22.0, fontFamily: 'SourceSansPro'),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0),
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      ),
    );
  }
}

class FriendList extends StatefulWidget {
  final String userID;
  Map<String, String> userFriends;
  FriendList(this.userID, this.userFriends);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  Map<String, String> userFriendName;

  void addFriend(String userFriendToken) async {
    userFriendName = await DatabaseService(widget.userID).addFriend(userFriendToken, widget.userFriends.keys.toList());
    if (userFriendName == null) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: kFourthColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
              ),
              title: Text("Error", style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro')),
              content: Text("Username does not exists or friend does already exist!", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SourceSansPro')),
            );
          });
    } else {
      setState(() {
        widget.userFriends[userFriendName.keys.toList().elementAt(0).toString()] = userFriendName.values.toList().elementAt(0).toString();
      });
    }
  }

  void deleteFriend(String friendUserID) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
          ),
          title: Text('Delete Friend?', style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure u want to delete?', style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SourceSansPro')),
              onPressed: () {
                DatabaseService(widget.userID).deleteFriend(friendUserID);
                setState(() {
                  widget.userFriends.remove(friendUserID);
                  print(widget.userFriends.values.toList().toString());
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SourceSansPro')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(20.0),
          child: TextField(
            onSubmitted: addFriend,
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Add Friend with Token", labelStyle: TextStyle(fontFamily: 'SourceSansPro')),
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.userFriends.length,
              itemBuilder: (context, i) {
                return Friend(widget.userFriends.values.toList()[i], () {
                  String key = widget.userFriends.keys.toList()[i].toString();
                  deleteFriend(key);
                });
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      decoration: BoxDecoration(
          color: kSecondaryColor, borderRadius: BorderRadius.all( Radius.circular(5.0)),
          boxShadow: [BoxShadow(color: kSecondaryColor.withOpacity(0.6), spreadRadius: 0, blurRadius: 0.0, offset: Offset(3, 3))]
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
          onPressed: () {
            remove();
          },
        ),
      ),
    );
  }
}
