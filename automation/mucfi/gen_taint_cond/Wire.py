from pathlib import Path
import sys

sys.path.append(Path(__file__).parents[0])

from Signal import Signal

class Wire(Signal):
    def __init__(self, name):
        super().__init__(name)
