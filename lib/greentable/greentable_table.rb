require 'greentable/greentable_counter'

module Greentable
  #class Column
  #  attr_accessor :attributes, :html, :tag
  #end

  class Table
    def initialize(parent, records, opts)
      @parent = parent
      @records = records
      @opts_tr = opts.delete(:tr) || {}
      @opts_td = opts.delete(:td) || {}
      @opts_th = opts.delete(:th) || {}
      @opts = opts

      @tr_attributes = []

      @th_attributes = []
      @th_html = []

      @td_attributes = []
      @td_html = []

    end

    def greensubrow(opts = {}, &block)
      return if capture_headers
      return if opts[:display_on] == :first && !@row_counter.first?
      return if opts[:display_on] == :last && !@row_counter.last?
      #@th_html[@col_counter] = th
      #@td_html[@col_counter] = capture(@records[@row_counter.i], self, &block)
    end

    #def current_row
    #  @rows_attributes[@counter.rows]
    #end

    def greencolumn(th = nil, opts = {}, &block)
      @th_html[@current_col] = th

      @td_html[@row_counter.i] ||= []
      @td_html[@row_counter.i][@current_col] = @parent.capture(&block)
      @td_attributes[@row_counter.i] = opts

      @current_col += 1
      return nil
    end

    def process(&block)
      @row_counter = Counter.new(@records.size)

      @records.each do |record|
        @current_col = 0
        block.call(self, record)
        @row_counter.inc
      end
    end

    def to_s
      ret = ""
      ret << "<table#{do_attributes(@opts)}>"
      ret << "<thead>"
      ret << "<tr>"
      @th_html.each do |th|
        ret << "<th#{do_attributes(@opts_th)}>#{th}</th>"
      end
      ret << "</tr>"
      ret << "</thead>"
      ret << "<tbody>"

      @row_counter.i.times do |i|
        ret << "<tr#{do_attributes(@opts_tr.merge(@tr_attributes[i]||{}))}>"
        @td_html[i].each do |td|
          ret << "<td#{do_attributes(@opts_td.merge(@td_attributes[i]||{}))}>#{td}</td>"
        end
        ret << "</tr>"
      end
      ret << "</tbody>"
      ret << "</table>"
    end

    private
    def do_attributes(o)
      return "" if o.nil? || o.empty?
      ret = o.map{|k,v| "#{k.is_a?(Proc) ? k.call.to_s : k.to_s}=\"#{v.is_a?(Proc) ? v.call.to_s : v.to_s}\""}.join(" ").strip
      ret = " " + ret unless ret.empty?
      return ret
    end
  end
end
