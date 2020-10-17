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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                eventIcon,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              builder: (context) => new GridView.count(
                    crossAxisCount: 3,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.add_rounded, size: 36,),
                            Text('Add', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),

                      IconButton(icon: Icon(Icons.add_rounded,), onPressed: null),
                      IconButton(icon: Icon(Icons.add_rounded,), onPressed: null),
                      IconButton(icon: Icon(Icons.add_rounded,), onPressed: null),
                      IconButton(icon: Icon(Icons.add_rounded,), onPressed: null),
                      IconButton(icon: Icon(Icons.add_rounded,), onPressed: null),
                    ],

                  )
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
