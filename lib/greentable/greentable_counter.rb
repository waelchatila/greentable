module Greentable
  class Counter
    def initialize(size)
      @i = 0
      @max = size
    end

    def i
      @i
    end

    def to_s
      @i.to_s
    end

    def first?
      @i == 0
    end

    def last?
      @i >= (@max-1)
    end

    def inc
      @i += 1
    end

    def odd?
      @i%2==0
    end

    def even?
      @i%2==1
    end

  end
end
