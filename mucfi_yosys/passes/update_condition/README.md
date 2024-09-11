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

## Open points
Flip flop and memory update condtions could be improved. In particular, when they are unconditionally updated at every clock cycle, it would be more precise to return the update condition of the right hand side (rhs) of the assignment. That would be more consistent with combinational assignments, where the update condition is also not constant high, but it is the update condition of the rhs.

### Potential Improvements
 opt_clean -purge could be used to remove output assignment to concatenations
 or write_verilog with -simplified_lhs

 Clock polarity is not considered.

## Assumptions
- The opt pass was run before the update condition pass.
- There are no combinational loops in the input signal's assignment.

