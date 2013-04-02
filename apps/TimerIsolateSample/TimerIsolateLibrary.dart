/*
  Dart code sample : Timer Isolate

  Function timerIsolate provides your application with accurate timings with
   +/- few mS accuracy depending on your pc's performance.

  note : Windows Vista, Windows Server 2008, Windows 7 or later required for this code.

  To try this sample:
    1. Put these codes into the holder named TimerIsolateSample.
    2. Create packages/browser directory in the TimerIsolateSample directory.
    3. Place dart.js bootstrap code in the packages/browser directory.
    4. Access TimerIsolateSample.html from Dartium like:
       file:///C:/...../TimerIsolateSample/TimerIsolateSample.html

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
*/

library TimerIsolateLibrary;
import 'dart:async';
import 'dart:isolate' as isolate;

// long-lived ports
var _receivePort;
var _sendPort;

// timer modes
final IDLE = 0;
final RUN  = 1;
final HOLD = 2;

// mode flag
var _mode = IDLE;
var _monitoring = false;

// variables
const int _tickMs = 20;   // use 20 ms tick
List _tripTimes;    // list of ms trip times
List _tripClocks;   // list of trips in Stopwatch clocks
List _expiredFlags; // expired flags correspond to tripTimes
var _mainProcess;   // main process object
Stopwatch _stopwatch;   // instance of Stopwatch
Timer _timer;       // instance of periodic timer

// top level timer isolate function
timerIsolate(){
  // establish communication link
  _receivePort = isolate.port;
  Completer completer = new Completer();
  Future linkEstablished = completer.future;
  _receivePort.receive((msg, replyTo){
    _sendPort = replyTo;
    replyTo.send('hello', _receivePort.toSendPort());
    completer.complete(true);
  });
  linkEstablished.then( (value) {
    _mainProcess = new _MainProcess();
    _mainProcess.run();
  });
}

// *** main process class ***

class _MainProcess {

 //local functions

  void run() {
    reset();
    _receivePort.receive(processCommands);
    Duration tick = const Duration(milliseconds: _tickMs);
  // we still have hang-up problem for Timer.repeating in isolate when started from Dartium
/*    _timer = new Timer.repeating(_tickMs, (Timer t){
    if (_mode == RUN) periodicMonitor();
    });
    _sendPort.send('isolate: end of _MainProcess.run()'); */
  }

  int reportCurrentTimerValue(){
    if (_mode == RUN || _mode == HOLD) { return (_stopwatch.elapsedMilliseconds);
    } else { return 0;
    }
  }

  void reset(){
    _stopwatch = new Stopwatch();
    _mode = IDLE;
    // default for just in case
    if (_tripTimes == null) _tripTimes = [500, 1000, 5000, 2000];
    _tripTimes.sort((a, b){return (a - b);});
    _expiredFlags = new List<bool>(_tripTimes.length);
    _tripClocks = new List<int>(_tripTimes.length);
    for(int i = 0; i < _expiredFlags.length; i++) _expiredFlags[i] = false;
    for(int i = 0; i < _tripClocks.length; i++) _tripClocks[i] = _tripTimes[i] * 1000;
    _sendPort.send('resetOk');
  }

  void start(){
    if (_mode == HOLD || _mode == IDLE){
      _stopwatch.start();
      _mode = RUN;
      _sendPort.send('startOk');
    }
  }

  void hold(){
    if (_mode == RUN){
      _stopwatch.stop();
      _mode = HOLD;
      _sendPort.send('holdOk');
    }
  }

  // periodic monitor
  periodicMonitor(){
    for(int i = 0; i < _tripTimes.length; i++) {
      if (_tripClocks[i] < (_stopwatch.elapsedMicroseconds + _tickMs * 1000) && _expiredFlags[i] == false) {
        do {} while (_tripClocks[i] >= _stopwatch.elapsedMicroseconds);
        _expiredFlags[i] = true;
        _sendPort.send({'expired' : _tripTimes[i]}); // report it immediately
      }
      else if ( _tripClocks[i] <= _stopwatch.elapsedMicroseconds && _expiredFlags[i] == false) {
        _expiredFlags[i] = true;
        _sendPort.send({'expired' : _tripTimes[i]}); // report it immediately
      }
    }
  }

  // command processor
  processCommands(msg, replyTo){
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
          _sendPort.send({'state':_mode});
          break;
        case '?elapsed' :
          _sendPort.send({'elapsed':reportCurrentTimerValue()});
          break;
        case '?expiredFlags' :
          _sendPort.send({'expiredFlags':_expiredFlags});
          break;
        case '?tripTimes' :
          _sendPort.send({'tripTimes':_tripTimes});
          break;
        default :
          if (_mode == RUN) _mainProcess.periodicMonitor();
      }
    }
    else if (msg is Map){
      if ((msg['tripTimes'] is List) && (_mode == IDLE)){
        _tripTimes = msg['tripTimes'];
        reset();
      }
    }
  }
}