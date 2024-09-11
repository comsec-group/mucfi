class SignalChunk:
    def __init__(self, msb, lsb):
        self.msb = msb
        self.lsb = lsb
        self.width = msb - lsb + 1
        self.range = "[" + str(msb) + ":" + str(lsb) + "]" if msb != lsb else "[" + str(msb) + "]"
        if self.width == 1:
            self.bitmask = "1'b1"
        else:
            # using the SystemVerilog replication operator
            self.bitmask = "{" + str(self.width) + "{1'b1}}"
        self.past = False
        self.expr = ""
        self.orig_name_expr = ""

    def set_expr(self, wire_expr):
        if not wire_expr:
            raise Exception(f"Trying to set an empty expression to chunk {self.range}.")
        self.expr = f"({wire_expr})"