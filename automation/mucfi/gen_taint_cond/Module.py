class Module:
    def __init__(self, name):
        self.name = name
        self.attributes = {}
        self.wires = {}
        self.regs = {}
        self.signals = {}