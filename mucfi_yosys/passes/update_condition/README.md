## Update condition pass

This pass generates the "udpate condition" for the signals provided as input. That is the condition in which the signal is assigned with a value from another signal (i.e., any condition in which it is not assigned with its own past value). E.g.
```
always @(posedge clk) begin
  if (c)
    a <= b;
end
```
The update condition of a is `$past(c)`.

E.g.
```
always @(posedge clk) begin
  if (c)
    a <= b;
  else
    a <= d;
end
```
The update condition of a is `1`, because a never keeps its value (unless cases like e.g. where c was true and b's past value matches a's previous value).

### Implementation

There are two options to use the pass:

1) Provide a signal_name for which the update condition should be generated.
2) Provide a signal_name and one or more signals in read-from-signals. In that case the condition in which the signal with signal_name reads from the read-from-signals.

Details:
1) The update condition (UC) is the condition in which the signal is assigned with a value from another signal (or constant), and not with its own previous value. That means for signals that are e.g. coninuously assigned with other signal values, the UC is 1. For a DFFE, it is the enable condition, potentially narrowed down by a further condition if the signal can be either assigned with it's own past value or another expression. Next, we will discuss the details.

The update condition or-connects the conditions in which a signal receives other values than it's own unmodified previous value.

- Search signal
- trace back the signal until one of these is reached:
	- a module input: ret 1
	- a signal that is found in the include list (e.g. reg): ret 1
	- a signal that is found in the exclude list (e.g. an already visited one): ret 0
	- a constant: ret 1
- if signal is assigned with a wire
	- ret uc(other side)
- if signal is at the output of a state element without enable:
	- ret uc(other side),
	- add past and keep attributes
- if signal is at the output of a MUX:
	- ret: !s && uc(a) || s && uc(b)
- if signal is a state element with enable:
	- (wrong: ret: $past(en) would assume that Q is not connected to D)
	- ret: $past(en && uc(d)) would be more equal to the mux
- if signal is driven by output of any other cell:
	- ret 1 (any cell perfoming a logic operation on a signal is not counted as a direct self assignment)
- if signal is assigned with a concatenation of signal chunks
	- ret 1 (this misses self-assignment cases like b[1:0] = {b[1], b[0]}.)

2) The read-from condition generation extracts only the condition in which a signal receives new data from specifically chosen read-from signals. Any other assignments with itself, other cells, constants, etc. are excluded (ie. the checks return 0 for that path).

### Potential Improvements
opt_clean -purge could be used to remove output assignment to concatenations
 or write_verilog with -simplified_lhs

The loop-handling is not ideal as it assumes that there are no combinational loops.

### Assumptions
- The opt pass was run before the update condition pass.
- There are no combinational loops in the input signal's assignment.