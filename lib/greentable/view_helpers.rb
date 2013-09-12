require 'greentable/greentable_table'

module Greentable
  module ViewHelpers
    def greentable(records, opts = {}, &block)
      begin
        gt = Table.new(self,records, opts)
        gt.process(&block)
        gt.to_s.html_safe
      rescue => e
        concat("<b>"+e.message+"</b><br><br>".html_safe)
        concat(e.backtrace.each{|x| x.to_s}.join('<br>').html_safe)
        return e
      end
    end

    private
  end
end
