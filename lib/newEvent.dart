import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'constants.dart';
import 'newEventFriends.dart';
// import 'main.dart';

class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_backspace_rounded)),
        title: Text(
          "New Event",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewEventFriends("🦆", "Eventtitle")),
                );
              },
              icon: Icon(Icons.arrow_forward_ios_rounded)),
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: EventEmoji(),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width * 0.58,
                      child: EventName(),
                    ),
                  ],
                ),
              ),
              EventDetails(),
              // EventDateTime(),
              EventTasks(),
            ],
          ),
        ),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class EventEmoji extends StatefulWidget {
  @override
  _EventEmojiState createState() => _EventEmojiState();
}

class _EventEmojiState extends State<EventEmoji> {
  void updateEventName(String text1) {
    setState(() {
      userText1 = text1;
    });
  }

  String userText1 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
        textAlign: TextAlign.center,
        onChanged: updateEventName,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          labelText: "Icon",
        ),
      );
  }
}

class EventName extends StatefulWidget {
  @override
  _EventNameState createState() => _EventNameState();
}

class _EventNameState extends State<EventName> {
  void updateEventName(String text2) {
    setState(() {
      userText2 = text2;
    });
  }

  String userText2 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventName,
      maxLength: 20,
      // TODO autofocus: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(),
          labelText: "Eventname"),
    );
  }
}

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  void updateEventDetails(String text3) {
    setState(() {
      userText3 = text3;
    });
  }

  String userText3 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventDetails,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(), labelText: "Eventdetails"),
    );
  }
}

// class EventDateTime extends StatefulWidget {
//   @override
//   _EventDateTimeState createState() => _EventDateTimeState();
// }
//
// class _EventDateTimeState extends State<EventDateTime> {
//   final format = DateFormat("yyyy-MM-dd HH:mm");
//   @override
//   Widget build(BuildContext context) {
//     return DateTimeField(
//           format: format,
//           onShowPicker: (context, currentValue) {
//             return showDatePicker(
//                 context: context,
//                 firstDate: DateTime(1900),
//                 initialDate: currentValue ?? DateTime.now(),
//                 lastDate: DateTime(2100));
//           },
//     );
//   }
// }

class EventTasks extends StatefulWidget {
  @override
  _EventTasksState createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  void addTask(String task) {
    setState(() {
      eventTask.add(task);
    });
    // Navigator.of(context).pop();
  }

  void deleteEventTask(int index) {
    setState(() {
      eventTask.removeAt(index);
    });
  }

  List<String> eventTask = [
    "Task1",
    "Task2",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onSubmitted: addTask,
            scrollPadding: EdgeInsets.only(bottom: 10.0),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Eventtasks"),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: eventTask.length,
              itemBuilder: (context, i) {
                return TaskItem(eventTask[i], () {
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
  final String taskname;
  final Function remove;
  const TaskItem(this.taskname, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
        title: Text(
          taskname,
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
