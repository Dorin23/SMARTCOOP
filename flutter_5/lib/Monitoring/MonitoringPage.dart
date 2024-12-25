import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_5/Monitoring/data_card_activationCount.dart';
import 'package:flutter_5/Monitoring/data_card_count.dart';
import 'package:flutter_5/Monitoring/data_card_light.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}) : super(key: key);

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  int lastLuminoz = -1;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('sensor');
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(int count, int activationCount) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    int notCount = count - activationCount;
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Coop Alert',
      '$notCount găini din $count nu sunt în adăpost',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
 double calculateLux(double lightSensor){
  double k =230752;
  return k/lightSensor;
 }
 List<double> lightValues = [];
 

bool isDecreasing = false;
  bool isIncreasing = false;
  int lastLightIntensity = 850; // Inițializare la 850 pentru a detecta prima scădere sub acest prag

  

int xorDecrypt(int encryptedData, int key) {
  return encryptedData ^ key;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
            stream: databaseRef.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
                final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                final int encryptedlight = data['light'] ?? 0;
                final int key = 3456;
                final int light = xorDecrypt(encryptedlight, key);
                double lightDouble = light.toDouble();
                //double light2 = encryptedlight.toDouble();
                final int count = data['count'] ?? 0;
                final int activationCount = data['activationCount'] ?? 0;
               
                if (light > 850 && lastLuminoz <= 850 && activationCount < count) {
                  _showNotification(count, activationCount);
                }
                lastLuminoz = light;
                return Column(
                  children: [
                    ListTile(
                      //title: Text('Light: $light'), 
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: DataCardCount(title: "Total", value: "$count",image: 'lib/google/black4.png',)),
                          Flexible(child: DataCardActivationCount(image:'lib/google/white2.png' , value: "$activationCount", title: "Coop",)),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey, 
                      height: 20, 
                      thickness: 2,
                      indent: 25,
                      endIndent: 25,
                    ),
                    
                     LightCard(luxValue: calculateLux(lightDouble)),
                   
                  ],
                ); 
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
