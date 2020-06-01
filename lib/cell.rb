class Cell
    attr_reader :x, :y
    attr_accessor :edges, :path

    def initialize(x, y)
        @x = x
        @y = y
        self.edges = []
        self.path = [[x, y]]
    end
end