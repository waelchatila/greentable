require 'greentable/greentable_table'

module Greentable
  module ViewHelpers
    def greentable(records, opts = {}, &block)
      gt = Table.new(self,records, opts)
      gt.process(&block)
      gt.to_s.html_safe
    end
  end
end
