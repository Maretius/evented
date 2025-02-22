import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'constants.dart';
import 'newEventFriends.dart';

class NewEvent extends StatefulWidget {
  final String userID;
  final String userName;
  final Map<String, String> userFriends;
  const NewEvent(this.userID, this.userName, this.userFriends);
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  void addTask(String task) {
    setState(() {
      _event.eventTasks.add(task);
    });
  }

  void deleteEventTask(int index) {
    setState(() {
      _event.eventTasks.removeAt(index);
    });
  }

  final dateFormat = DateFormat("dd.MM.yyyy - HH:mm");
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _event = EventSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.keyboard_backspace_rounded)),
        title: Text("New Event", style: TextStyle(fontSize: 24.0,fontFamily: 'SourceSansPro')),
        actions: [
          IconButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewEventFriends(widget.userID, widget.userName, widget.userFriends, _event.eventIcon, _event.eventName, _event.eventDetails, _event.eventDateTime, _event.eventTasks)),
                  );
                }
              },
              icon: Icon(Icons.arrow_forward_ios_rounded)),
        ],
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryBackgroundColor,
      body: Center(
          child: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 36.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            child: TextFormField(
                              validator: (value) {
                                final RegExp emojiregex = new RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
                                if (value.isEmpty) {
                                  return 'Please enter Eventicon';
                                } else if (!emojiregex.hasMatch(value) || value.length > 2) {
                                  return '1 Emoji';
                                }
                                return null;
                              },
                              onSaved: (val) => setState(() => _event.eventIcon = val),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: "Icon",
                              ),
                              style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro'),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.58,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Eventname';
                                }
                                return null;
                              },
                              onSaved: (val) => setState(() => _event.eventName = val),
                              maxLength: 20,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: "Eventname",
                              ),
                              style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some Eventdetails';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _event.eventDetails = val),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdetails"),
                      style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro'),
                    ),
                    DateTimeField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter Date & Time';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _event.eventDateTime = val),
                      // URL: https://pub.dev/packages/datetime_picker_formfield
                      format: dateFormat,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(context: context, firstDate: DateTime.now(), initialDate: currentValue ?? DateTime.now(), lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdate & Time"),
                      style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                            child: TextFormField(
                              controller: _controller,
                              onFieldSubmitted: (value) {
                                if (value != ""){
                                  addTask(value);
                                  _controller.clear();
                                }
                              },
                              scrollPadding: EdgeInsets.only(bottom: 10.0),
                              decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventtasks"),
                              style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro'),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            //scrollDirection: Axis.vertical,
                            itemCount: _event.eventTasks.length,
                            itemBuilder: (context, i) {
                              return TaskItem(_event.eventTasks[i], () {
                                deleteEventTask(i);
                              });
                              },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String taskName;
  final Function remove;
  const TaskItem(this.taskName, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.all( Radius.circular(5.0)),
          boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.6), spreadRadius: 0, blurRadius: 0.0, offset: Offset(3, 3))]
      ),
      child: ListTile(
        title: Text(taskName, style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'SourceSansPro')),
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

class EventSettings {
  String eventIcon;
  String eventName;
  String eventDetails;
  DateTime eventDateTime;
  List<String> eventTasks = [
    "Example Task",
  ];
}