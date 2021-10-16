import std.stdio;
import std.concurrency;
import core.thread;

void MessageHandler() {
	while(true) {
		receive( 
			(int message) {writeln(message);} 
		);
		writeln("[MessageHandler] message manager update.");
	}
}

void DatabaseProgram(Tid msg_handler_TiD) {
	writeln("[DatabaseProgram] upload bulk data. one time.");
	int number_of_calls = 0;
    Fiber.yield();
    while(true) {
    	writeln("[DatabaseProgram] tried to update data. once per day.");
    	number_of_calls += 1;
    	send(msg_handler_TiD, 13);
    	if(number_of_calls == 5) {
    		writeln("[DatabaseProgram] Fifth update of the day.");
    		number_of_calls = 0;
    		string msg = "database_updated";
    		
    		Thread.sleep( 1.seconds );
    	}
    	Fiber.yield();
    }
}

void main() {
    scheduler = new FiberScheduler;
    scheduler.start( 
    {
        writeln("[main] Fiber application.");
        auto f_0 = spawn( &MessageHandler );
        auto f_1 = spawn( &DatabaseProgram, f_0 );
        send(f_0, 13);
        send(f_0, 17);
    });
}
