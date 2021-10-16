import std.stdio;
import std.concurrency;
import core.thread: Fiber;

void DatabaseProgram() {
	writeln("[Database program] upload bulk data. one time.");
	int number_of_calls = 0;
    Fiber.yield();
    while(true) {
    	writeln("[Database program] tried to update data. once per day.");
    	number_of_calls += 1;
    	if(number_of_calls == 5) {
    		number_of_calls = 0;
    		// send message here.
    	}
    	Fiber.yield();
    }
}

void Program_1() {
	writeln("[Program_1] buy/sell, do some initial things.");
	Fiber.yield();
    while(true) {
    	writeln("[Program_1] trying to update.");
    	Fiber.yield();
    }	
}

void main() {
    scheduler = new FiberScheduler;
    scheduler.start( 
    {
        writeln("[main] Fiber application.");
        auto f_1 = spawn( &DatabaseProgram );
        auto f_2 = spawn( &Program_1 );
    });
}
