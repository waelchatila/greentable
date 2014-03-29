require 'greentable/greentable_table'

module Greentable
  module ViewHelpers
    def greentable(records, opts = {}, &block)
      gt = Table.new(self,records, opts)
      gt.process(&block)
    end
  end
end
