import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/models/event.dart';
import 'package:vanevents/models/formule.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:vanevents/shared/indicator.dart';
import 'package:vanevents/shared/topAppBar.dart';

class MonitoringScanner extends StatefulWidget {
  final String eventId;

  MonitoringScanner(this.eventId);

  @override
  _MonitoringScannerState createState() => _MonitoringScannerState();
}

class _MonitoringScannerState extends State<MonitoringScanner> {
  GlobalKey qrKey = GlobalKey();
  String data = '';
  int nbAttendu = 0;
  int nbPresent = 0;
  StreamController<PieTouchResponse> pieTouchedResultStreamController;
  int touchedIndex=-1, lastTouched=-1;
  List<PieChartSectionData> _listPieChart = List<PieChartSectionData>();
  List<Indicator> _listIndicator = List<Indicator>();
  Stream<Event> event;
  List<Formule> formules;

  String pourcentage = '0 %';

  @override
  void initState() {


    super.initState();
  }

  @override
  void dispose() {
    pieTouchedResultStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase db =
        Provider.of<FirestoreDatabase>(context, listen: false);

    //initValue(db);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: TopAppBar('Monitoring', false, null, double.infinity),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IntrinsicHeight(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.yellow,
                        child: Card(
                          color:Theme.of(context).colorScheme.surface,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Wrap(
                                alignment: WrapAlignment.spaceAround,
                                spacing: 40,
                                direction: Axis.horizontal,
                                runSpacing: 5,
                                children: _listIndicator,
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(
                                          touchCallback: (pieTouchResponse) {
                                            setState(() {
                                              if (pieTouchResponse.touchInput
                                              is FlLongPressEnd ||
                                                  pieTouchResponse.touchInput is FlPanEnd) {
                                                touchedIndex = -1;
                                              } else {
                                                touchedIndex =
                                                    pieTouchResponse.touchedSectionIndex;
                                              }
                                            });
                                          }),
                                      startDegreeOffset: 180,
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 60,
                                      sections: showingSections()),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: Center(
                            child: Text(
                              pourcentage,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await MajaScan.startScan(
          title: "QRcode scanner",
          titleColor: Colors.amberAccent[700],
          qRCornerColor: Colors.orange,
          qRScannerColor: Colors.orange);
      setState(() {
        data = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          data = "Camera permission was denied";
        });
      } else {
        setState(() {
          data = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        data = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        data = "Unknown Error $ex";
      });
    }
  }

  List<PieChartSectionData> showingSections() {


    _listIndicator.clear();
    _listPieChart.clear();



    _listPieChart.add(PieChartSectionData(
      color: Theme.of(context).colorScheme.onSecondary,
      value:nbPresent.toDouble(),
      title: nbPresent.toString(),
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    ));


    _listIndicator.add(
      Indicator(
        color: Theme.of(context).colorScheme.onSecondary,
        text: 'Present',
        isSquare: false,
        size: 16,
        textColor: Colors.grey,
      ),
    );
    _listPieChart.add(PieChartSectionData(
      color: Theme.of(context).colorScheme.primary,
      value: nbAttendu.toDouble(),
      title: nbAttendu.toString(),
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    ));

    _listIndicator.add(
      Indicator(
        color: Colors.red,
        text: 'Attendu',
        isSquare: false,
        size: 16,
        textColor: Colors.grey,
      ),
    );

    return List.generate(_listPieChart.length, (i) {
      final isTouched = i == touchedIndex;
      final double opacity = isTouched ? 1 : 0.6;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

      PieChartSectionData pieChartSectionData = _listPieChart.elementAt(i);

      return pieChartSectionData.copyWith(
        color: pieChartSectionData.color.withOpacity(opacity),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  void initValue(FirestoreDatabase db){

    event = db.eventStream(widget.eventId);

    event.listen((event){

      nbPresent = event.nbExpected;

    }
    );

    db.formuleList(widget.eventId).then((list){

      list.forEach((formule){

        nbAttendu += formule.nombreDePersonne;

      });

//      setState(() {
//        //pourcentage = ((nbPresent*100)/nbAttendu).toString()+' %';
//        pourcentage = '10';
//      });

    });

//    pieTouchedResultStreamController = StreamController();
//    pieTouchedResultStreamController.stream.distinct().listen((details) {
//      if (details == null) {
//        return;
//      }
//
//      setState(() {
//        if (details.touchInput is FlLongPressEnd) {
//          touchedIndex = -1;
//        } else {
//          touchedIndex = details.touchedSectionIndex;
//        }
//
//        //highlight indicator
//        if (touchedIndex != null && touchedIndex >= 0) {
//          lastTouched = touchedIndex;
//          _listIndicator.insert(
//            touchedIndex,
//            Indicator(
//              color: Colors.primaries[touchedIndex % Colors.primaries.length],
//              text: _listIndicator.elementAt(touchedIndex).text,
//              isSquare: false,
//              size: 18,
//              textColor: Colors.black,
//            ),
//          );
//          _listIndicator.removeAt(touchedIndex + 1);
//        } else if (lastTouched != null) {
//          _listIndicator.insert(
//            lastTouched,
//            Indicator(
//              color: Colors.primaries[lastTouched % Colors.primaries.length],
//              text: _listIndicator.elementAt(lastTouched).text,
//              isSquare: false,
//              size: 16,
//              textColor: Colors.grey,
//            ),
//          );
//
//          _listIndicator.removeAt(lastTouched + 1);
//        }
//      });
//    });
  }
}
