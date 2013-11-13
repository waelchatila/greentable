require 'greentable/configuration'
require 'greentable/greentable_counter'

module Greentable

  class Table
    def initialize(parent, records, opts)
      @parent = parent
      @records = records
      defaults = Greentable.configuration.defaults.clone rescue {}
      @defaults_tr = (defaults.delete(:tr) || {}).deep_merge(opts.delete(:tr) || {})
      @defaults_th = (defaults.delete(:th) || {}).deep_merge(opts.delete(:th) || {})
      @defaults_td = (defaults.delete(:td) || {}).deep_merge(opts.delete(:td) || {})
      @opts = defaults.deep_merge(opts)

      #rows
      @tr_attributes = []

      #cols
      @th_attributes = []
      @th_html = []
      @td_attributes = []
      @td_html = []

    end

    def subrow(opts = {}, &block)
      return if capture_headers
      return if opts[:display_on] == :first && !@row_counter.first?
      return if opts[:display_on] == :last && !@row_counter.last?
    end

    def col(th = nil, opts = {}, &block)
      @th_html[@current_col] = th
      @th_attributes[@current_col] = opts.delete(:th) || {}
      @td_attributes[@current_col] = opts

      @td_html[@row_counter.i] ||= []
      @td_html[@row_counter.i][@current_col] = @parent.capture(&block)

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
      return ret if @td_html.empty?
      ret << "<table#{do_attributes(nil,@opts)}>"
      unless @th_html.compact.empty?
        ret << "<thead>"
        ret << "<tr>"
        @th_html.each_with_index do |th,col|
          ret << "<th#{do_attributes(nil,@th_attributes[col])}>#{th.is_a?(Proc) ? th.call.to_s : th}</th>"
        end
        ret << "</tr>"
        ret << "</thead>"
      end
      ret << "<tbody>"

      @row_counter.i.times do |row|
        ret << "<tr#{do_attributes(row,@defaults_tr.deep_merge(@tr_attributes[row]||{}))}>"
        @td_html[row].each_with_index do |td,col|
          ret << "<td#{do_attributes(row,@defaults_td.deep_merge(@td_attributes[col]||{}))}>#{td}</td>"
        end
        ret << "</tr>"
      end
      ret << "</tbody>"
      ret << "</table>"
    end

    private
    def do_attributes(i,o)
      instance = i.nil? ? nil : @records[i]
      return "" if o.nil? || o.empty?
      ret = o.map{|k,v| "#{k.is_a?(Proc) ? instance.instance_eval(&k).to_s : k.to_s}=\"#{v.is_a?(Proc) ? instance.instance_eval(&v).to_s : v.to_s}\""}.join(" ").strip
      ret = " " + ret unless ret.empty?
      return ret
    end

  end
end
