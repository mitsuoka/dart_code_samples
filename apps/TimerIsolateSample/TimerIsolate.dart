/*
  Dart code sample : Timer Isolate

  timerIsolate provides your application with accurate timings with
   +/- few mS accuracy depending on your pc's performance.

  note : Windows Vista, Windows Server 2008, Windows 7 or later required for this code.

  To try this sample from the Dart Editor:
    1. Put these codes into the holder named TimerIsolateSample.
    2. Select pubspec.yaml, right click, and select 'Pub Get'.
    3. Select TimerIsolateSample.html, right click, and select 'Run in Dartium'.

  Messages:
    To the timer:
      1. "reset" ： Command to reset the timer. Accepted at HOLD and RUN modes.
      2. "start" ： Command to start the timer. Accepted at IDLE and HOLD modes.
      3. "hold" ： Command to hold the timer. Accepted at RUN mode.
      4. "?state" ： Query to send the current mode.
      5. "?elapsed" : Query to send the current elapsed time.
      6. "?expiredFlags" : Query to send the current expired setting flags.
      7. "?tripTimes" : Query to send the trip time settings.
      8. {'tripTimes' : [camma separated trip times in mS]} ： Set tripps. Accepted at IDLE mode. Causes implicit reset.
      9. "tick" : Provisional tick to the timer isolate. Will be removed after the API revision.
      10."quit" : Command to disconnect the timer.
    From the timer:
      1. "resetOk" ： Acknowledgement to the reset command.
      2. "startOk" ： Acknowledgement to the start command.
      3. "holdOk" ： Acknowledgement to the hold command.
      4. {'state' : int current_mode} ： Current mode. Corresponds to "?state" query.
      5. {'elapsed' : int elapsed_time_in_ms} ： Corresponds to "?elapsed" query.
      6. {'expiredFlags' : List<bool>} ：　Correspond to "?expiredFlags" query.
      7. {'tripTimes' : List trip_times} ：　Correspons to "?tripTimes" query.
      8. {'expired' : int timer_value} ： Announcement that the timer has expired one of trip settings.

  Tested on Dartium.
  Refer to : www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf (in Japanese)
  April 2012, by Cresc Corp.
  August 2012, modified to cope with API changes
  October 2012, modified to incorporate M1 changes
  January 2013, incorporated API changes
  November 2013, incorporated breaking dart:isolate changes
*/

import 'dart:async';
import 'dart:isolate';

// long-lived ports
var receivePort;
var sendPort;

// isolate status
final CONNECTING = 1;
final CONNECTED = 2;
final STOPPED = 3;
var status;
TimerIsolate timerIsolate;

// top level main function
void main(List<String> args, SendPort port) {
  timerIsolate = new TimerIsolate(); // create isolate instance
  status = CONNECTING;
  receivePort = new ReceivePort();
  sendPort = port;
  sendPort.send(receivePort.sendPort);  // initiate link establishment
  receivePort.listen((msg){             // receive messages and dispatch them
    if (status == CONNECTED) timerIsolate.run(msg);
    else if (status == CONNECTING) linkEstablish(msg);
  });
}

  // establish communication link
linkEstablish(msg){
  if (msg == 'ping') {
    sendPort.send('pong');
    status = CONNECTED;
    sendLog('child received : $msg');
    timerIsolate.run();
  }
}


// timer isolate class
class TimerIsolate {

  // timer modes
  final IDLE = 0;
  final RUN  = 1;
  final HOLD = 2;

  // mode flag
  var mode;
  bool monitoring;

  // monitoring tick
  int tickMs = 20;     // use 20 ms tick
  Duration tick;

  // variables
  List tripTimes;      // list of ms trip times
  List tripClocks;     // list of trips in Stopwatch clocks
  List expiredFlags;   // expired flags correspond to tripTimes
  Stopwatch stopwatch; // instance of Stopwatch
  Timer timer;         // instance of periodic timer

  // constructor
  TimerIsolate() {
    mode = IDLE;
    monitoring = false;
    tick = new Duration(milliseconds: tickMs);
  }

  void run([msg = null]) {
    if (msg == null) {
      reset();
      // we still have hang-up problem for Timer.repeating in isolate when started from Dartium
//      timer = new Timer.periodic(tick, (Timer t){
//        if (mode == RUN) periodicMonitor();
//        });
      sendPort.send('isolate: end of timerIsolate.run()');
    }
    else processCommands(msg);
  }

  int reportCurrentTimerValue(){
    if (mode == RUN || mode == HOLD) { return (stopwatch.elapsedMilliseconds);
    } else { return 0;    }
  }

  void reset(){
    stopwatch = new Stopwatch();
    mode = IDLE;
    // default for just in case
    if (tripTimes == null) tripTimes = [500, 1000, 5000, 2000];
    tripTimes.sort((a, b){return (a - b);});
    expiredFlags = new List<bool>(tripTimes.length);
    tripClocks = new List<int>(tripTimes.length);
    for(int i = 0; i < expiredFlags.length; i++) expiredFlags[i] = false;
    for(int i = 0; i < tripClocks.length; i++) tripClocks[i] = tripTimes[i] * 1000;
    sendPort.send('resetOk');
  }

  void start(){
    if (mode == HOLD || mode == IDLE){
      stopwatch.start();
      mode = RUN;
      sendPort.send('startOk');
    }
  }

  void hold(){
    if (mode == RUN){
      stopwatch.stop();
      mode = HOLD;
      sendPort.send('holdOk');
    }
  }

  // periodic monitor
  periodicMonitor(){
    for(int i = 0; i < tripTimes.length; i++) {
      if (tripClocks[i] < (stopwatch.elapsedMicroseconds + tickMs * 1000) && expiredFlags[i] == false) {
        do {} while (tripClocks[i] >= stopwatch.elapsedMicroseconds);
        expiredFlags[i] = true;
        sendPort.send({'expired' : tripTimes[i]}); // report it immediately
      }
      else if ( tripClocks[i] <= stopwatch.elapsedMicroseconds && expiredFlags[i] == false) {
        expiredFlags[i] = true;
        sendPort.send({'expired' : tripTimes[i]}); // report it immediately
      }
    }
  }

  // command processor
  processCommands(msg){
    if (msg is String){
      switch(msg) {
        case 'reset' :
          reset();
          break;
        case 'start' :
          start();
          break;
        case 'hold' :
          hold();
          break;
        case '?state' :
          sendPort.send({'state':mode});
          break;
        case '?elapsed' :
          sendPort.send({'elapsed':reportCurrentTimerValue()});
          break;
        case '?expiredFlags' :
          sendPort.send({'expiredFlags':expiredFlags});
          break;
        case '?tripTimes' :
          sendPort.send({'tripTimes':tripTimes});
          break;
        case 'quit' :
          status = STOPPED;
          sendLog('child closed it\'s port');
          receivePort.close();
          break;
        default :
          if (mode == RUN) periodicMonitor();
      }
    }
    else if (msg is Map){
      if ((msg['tripTimes'] is List) && (mode == IDLE)){
        tripTimes = msg['tripTimes'];
        reset();
      }
    }
  }
}


// return log to the parent
void sendLog(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  sendPort.send('$timestamp : $msg');
}