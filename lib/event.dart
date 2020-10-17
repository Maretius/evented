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
            child:
              Text(
                eventIcon,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                    crossAxisCount: 2,
                    scrollDirection: Axis.horizontal,
                   childAspectRatio: (3/2),


                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add_rounded, size: 36,), onPressed: null, ),
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
