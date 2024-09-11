from pathlib import Path
import sys
sys.path.append(str(Path(__file__).parents[0]))

from Signal import Signal

class Reg(Signal):
    def __init__(self, name, declaration="", expr=""):
        super().__init__(name)
        self.declaration = declaration
        self.expr = expr
