import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
// import 'main.dart';
// import 'newEvent.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  const Event(this.eventIcon, this.eventTitle, this.eventDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        centerTitle: true,
        title: Text(
          eventTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            alignment: Alignment.center,
            child: IconButton(
              icon: Text(
                eventIcon,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return SimpleDialog(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.vertical(
                              top: Radius.circular(20.0),
                              bottom: Radius.circular(20.0)),
                        ),
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  eventDetails,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          ),
                        ]);
                  },
                );
              },
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
        bottom: PreferredSize(
          preferredSize: Size(0.0, 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "01.01.2020",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                "13:30 Uhr",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.vertical(
                  top: Radius.circular(20.0), bottom: Radius.zero),
            ),
            builder: (context) => new GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              children: <Widget>[
                ButtonContainer(Icons.event_note_rounded, "Change Details",
                    "changeDetails", eventDetails),
                ButtonContainer(Icons.person_add_alt_1_rounded,
                    "Invite Friends", "inviteFriends", eventDetails),
                ButtonContainer(Icons.menu_open_rounded, "Add Task", "addTask", eventDetails),
                ButtonContainer(
                    Icons.date_range_rounded, "Change Date", "changeDate", eventDetails),
                ButtonContainer(
                    Icons.access_time_rounded, "Change Time", "changeTime", eventDetails),
                ButtonContainer(Icons.delete_forever_rounded, "Delete Event",
                    "deleteEvent", eventDetails),
              ],
            ),
          );
        },
        child: Icon(
          Icons.settings_rounded,
          size: 32.0,
        ),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer(this.buttonIcon, this.buttonText, this.buttonTheme, this.eventDetails);
  final IconData buttonIcon;
  final String buttonText;
  final String buttonTheme;
  final String eventDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              buttonIcon,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              if (buttonTheme == "changeDetails") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(5.0))),
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: TextField(
                            // onChanged: updateEventDetails,
                            controller: TextEditingController()..text = eventDetails,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            maxLength: 200,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Eventdetails"),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.check_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (buttonTheme == "inviteFriends") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1.0,
                    crossAxisCount: 3,
                    children: <Widget>[],
                  ),
                );
              }
              if (buttonTheme == "addTask") {
              } else if (buttonTheme == "changeDate") {
              } else if (buttonTheme == "changeTime") {
              } else if (buttonTheme == "deleteEvent") {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext cxt) {
                    return AlertDialog(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.vertical(
                            top: Radius.circular(20.0),
                            bottom: Radius.circular(20.0)),
                      ),
                      title: Text(
                        'Delete Event?',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              'Are you sure u wanna delete the event?',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Deleted Events cant be restored!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(color: kTextColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: kTextColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
