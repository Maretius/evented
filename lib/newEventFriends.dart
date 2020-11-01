import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'constants.dart';
import 'main.dart';
//import 'newEvent.dart';

class NewEventFriends extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  const NewEventFriends(this.eventIcon, this.eventTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace_rounded),
        ),
        title: Text(
          eventTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Evented()),
                );
              },
              icon: Icon(Icons.check_rounded)),
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: EventFriends(),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class EventFriends extends StatefulWidget {
  @override
  _EventFriendsState createState() => _EventFriendsState();
}

class _EventFriendsState extends State<EventFriends> {
  void addFriend(String task) {
    setState(() {
      eventFriend.add(task);
    });
    // Navigator.of(context).pop();
  }

  void deleteEventTask(int index) {
    setState(() {
      eventFriend.removeAt(index);
    });
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<String> eventFriend = [
    "Friend 1",
    "Friend 2",
  ];
  List<String> suggestions = [
    "Chris",
    "Hannes",
    "Jeremy",
    "Pascal",
    "Axel",
    "Gertrude",
    "Buglunde",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SimpleAutoCompleteTextField(
                key: key,
                suggestions: null,
                clearOnSubmit: true,
                textSubmitted: (text) {
                  setState(() {
                    if (text != '') {
                      addFriend(text);
                    }
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Friends"),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Friends"),
                ),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Ink(
                    decoration: ShapeDecoration(
                        color: kPrimaryColor, shape: CircleBorder()),
                    child: IconButton(
                      onPressed: () {
                        addFriend;
                      },
                      icon: Icon(Icons.add_rounded),
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: eventFriend.length,
              itemBuilder: (context, i) {
                return TaskItem(eventFriend[i], () {
                  deleteEventTask(i);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String friendName;
  final Function remove;
  const TaskItem(this.friendName, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 3.0),
        title: Text(
          friendName,
          style: TextStyle(
            fontSize: 20.0,
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
