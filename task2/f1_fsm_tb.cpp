#include "Vf1_fsm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;
    int pause_cycles = 0;
    bool paused = false;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vf1_fsm* top = new Vf1_fsm;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("f1_fsm.vcd");

    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 3: F1 Seq");

    vbdSetMode(1);

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->ld = 0;

    // run simulation for many clock cycles
    for (i=0; i<100000; i++) {

        // dump variables into VCD file and toggle clock

        // for each clock cycle, we toggle the clock signal twice, representing the rising and falling edge
        for (clk=0; clk<2; clk++){
            tfp->dump (2*i+clk); // using 2i + clk allows us to see the "within the clock cycle", representing accuractely the time ponit in the simulation
            top->clk = !top->clk; // This toggles the clock signal between high and low (simply negating itself), simulating the clock cycle.
            top->eval (); // the eval function tells Verilator to evaluate the current state in the device under test (DUT).
            // This means we are updating the internal logic of the counter based of the new input values.
        }

        // Update the increment value based on vbdValue() to change the frequency
        top->ld = vbdFlag();

        vbdBar(top->data_out & 0xFF);
        vbdCycle(i+1);

        // This checks whether the simulation has been signaled to stop, which would cause an early exit.
        if (Verilated::gotFinish() || vbdGetkey()=='`') exit(0);

    }
    // This finalize the waveform for GTKWave, and exit(0) exits the program.

    vbdClose();
    tfp->close();
    exit(0);
}
