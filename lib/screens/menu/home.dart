import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(7, 10, 7, 0),
          child: ListView(
            children: <Widget>[
              _header(),
              _clients(),

              //Divider(),

              //_contents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("KlikLaw",),
            ],
          )
        ],
      )
    );
  }

  Widget _clients(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'You have 5 clients currently',
              style: TextStyle(
                  fontSize: 15
              ),
            ),

            FlatButton( // See All Button
              child: Text(
                "See all",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                //showToast("See all", context);
                //Navigator.pushNamed(context, Routes.categories);
              },
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'See or top up your balance',
              style: TextStyle(
                  fontSize: 15
              ),
            ),

            FlatButton( // See All Button
              child: Text(
                "Detail",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                //showToast("See all", context);
                //Navigator.pushNamed(context, Routes.categories);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _contents(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),

          Text(
            'Features',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Still nothing
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[

                      Image.asset(
                        'assets/general_services.jpg',
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin:Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.2, 0.7],
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ]
                            )
                        ),
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                      ),

                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.height/5,
                          padding: EdgeInsets.all(1),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Clients',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  // Still nothing
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[

                      Image.asset(
                        'assets/accounting.jpg',
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin:Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.2, 0.7],
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ]
                            )
                        ),
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                      ),

                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.height/5,
                          padding: EdgeInsets.all(1),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Statistics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Still nothing
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[

                      Image.asset(
                        'assets/human_resource.jpg',
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin:Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.2, 0.7],
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ]
                            )
                        ),
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                      ),

                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.height/5,
                          padding: EdgeInsets.all(1),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Forums',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  // Still nothing
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[

                      Image.asset(
                        'assets/legal.jpg',
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                                begin:Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.2, 0.7],
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ]
                            )
                        ),
                        height: MediaQuery.of(context).size.height/4,
                        width: MediaQuery.of(context).size.height/5,
                      ),

                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.height/5,
                          padding: EdgeInsets.all(1),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Others',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}