import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
// import 'main.dart';
// import 'newEvent.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  const Event(this.eventIcon, this.eventTitle);

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
            child: Text(
              eventIcon,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
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
                ButtonContainer(
                    Icons.person_add_alt_1_rounded, "Invite Friends", null),
                ButtonContainer(Icons.menu_open_rounded, "Add Task", null),
                ButtonContainer(Icons.date_range_rounded, "Change Date", null),
                ButtonContainer(Icons.access_time_rounded, "Change Time", null),
                ButtonContainer(
                    Icons.delete_forever_rounded, "Delete Event", null),
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
  const ButtonContainer(this.buttonIcon, this.buttonText, this.buttonTheme);
  final IconData buttonIcon;
  final String buttonText;
  final String buttonTheme;
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
            onPressed: null,
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
