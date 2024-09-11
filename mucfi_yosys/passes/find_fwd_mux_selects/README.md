## Find forwarding multiplexers pass

This pass automatically finds forwarding multiplexers, which arbitrate between a provided forwarding signal and a provided register read signal. Forwarding input and register read signals may be directly connected to the multiplexer (mux), or via some undelayed and non-transformative assignments. The pass then tags the select of these multiplexers with the keyword FORMAL_ABSTRACT.

The pass also checks whether the following declassification precondition is satisfied by the design:
"all outgoing paths from a declassified
signal converge either into another declassified signal or one of the
SRC inputs to instructions before reaching the PC."

Taint injection into the register read signal is sound, if there is no logic between the register output and the register reading signals. This can be checked by running the pass and providing the register file name (the name of the first element, because we run a pass that breaks down memories beforehand) as register read signal. There are 3 possible outcomes:

- If the same multiplexers are tagged as when passing the true register read signal that is used in the formal setup as register read signal, there is no extra logic between the register and it's reading signal. Therefore, the register reading condition can be used as taint injection condition.
- If there are other forwarding multiplexers (fmux) tagged, their forwarding input select condition has to be considered in the taint injection.
- If no forwarding multiplexer is tagged, there is extra logic between the register output and the register read signal, which is not a forwarding multiplexer. This can be the case if the reg read signal is conditionally reading from the register file.


## Algorithm

The pass takes a forwarding output signal (that should be declassified in the formal setup, ie., abstracted and set to 'not tainted'), the register read signal, the register write signal and the program counter (PC) signal as input.
Starting from the forwarding output, the pass follows all outgoing paths of this signal and checks whether it eiter feeds into a declassified signal (precondition fulfilled), or into a multiplexer. Then it checks whether this multiplexer is a forwarding multiplexer. If yes, the mux is tagged. If nto, the search is continued at the output of the mux. Assignments and port connections are followed until a forwarding multiplexer is found. If a path feeds into another cell, the pass checks whether all outgoing paths converge into a declassified signal without passing the PC.

While checking whether a multiplexer is a forwarding multiplexer, the pass also checks for precondition that needs to be satisfied when abstracting the select of a multiplexer (instead of injecting taint into the forwarding input of that multiplexer): There must be no other cell than an fmux (or a non-transformative cell combination like a double negation) between the forwarding input of the fmux and the register reading signal. If the precondition is not fulfilled, the multiplexer is not tagged as forwarding multiplexer and the search continues at the output of the mux (as described above).
