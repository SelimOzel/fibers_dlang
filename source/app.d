import std.stdio;
import std.concurrency;
import core.thread;

struct Done {}

void MessageHandler() {
  bool done = false;
  while(!done) {
    writeln("[MessageHandler] message manager update.");
    // non-blocking receive
    receiveTimeout(
      -1.seconds,
      (int message) {writeln(message);},
      (Done message) {done = true;}
    );
  }
}

void DatabaseProgram(Tid msg_handler_TiD, Tid parent_TiD) {
  writeln("[DatabaseProgram] upload bulk data. one time.");
  for (int i = 0; i<3; i++) {
    writeln("[DatabaseProgram] tried to update data. once per day.");
    send(msg_handler_TiD, i);
    Thread.sleep( 1.seconds );
  }

  // Terminate all threads and end program
  send(msg_handler_TiD, Done());
  send(parent_TiD, Done());
}

void main() {
  scheduler = new FiberScheduler;
  scheduler.start( 
  {
	writeln("[main] Fiber application.");
    auto f_0 = spawn( &MessageHandler );
    auto f_1 = spawn( &DatabaseProgram, f_0, thisTid );
    bool done = false;
    while(!done) {
      receiveTimeout(-1.seconds, (Done message) {done = true;});
      Thread.sleep( 1.seconds );
    }
  });
}
