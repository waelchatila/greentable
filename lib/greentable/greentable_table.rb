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

      @tr_attributes = []
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
      ret << "<table#{do_attributes(@opts)}>"
      unless @th_html.compact.empty?
        ret << "<thead>"
        ret << "<tr>"
        @th_html.each_with_index do |th,i|
          ret << "<th#{do_attributes(@defaults_th.deep_merge(@th_attributes[i]||{}))}>#{th.is_a?(Proc) ? th.call.to_s : th}</th>"
        end
        ret << "</tr>"
        ret << "</thead>"
      end
      ret << "<tbody>"

      @row_counter.i.times do |i|
        ret << "<tr#{do_attributes(@defaults_tr.deep_merge(@tr_attributes[i]||{}))}>"
        @td_html[i].each do |td|
          ret << "<td#{do_attributes(@defaults_td.deep_merge(@td_attributes[i]||{}))}>#{td}</td>"
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
