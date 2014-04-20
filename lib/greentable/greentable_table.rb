require 'greentable/configuration'
require 'greentable/greentable_counter'

module Greentable

  class Table
    def initialize(parent, records, opts)
      @parent = parent
      @records = records
      @row_counter = Counter.new(@records.size)

      defaults = Greentable.configuration.defaults.dup rescue {}
      @defaults_tr = deep_merge(defaults.delete(:tr), opts.delete(:tr))
      @defaults_th = deep_merge(defaults.delete(:th), opts.delete(:th))
      @defaults_td = deep_merge(defaults.delete(:td), opts.delete(:td))
      @opts = deep_merge(defaults, opts)

      #rows
      @tr_attributes = []

      #cols
      @th_attributes = []
      @th_html = []
      @td_attributes = []
      @td_html = []

      @tfoot = ""
    end

    def counter
      @row_counter
    end

    def col(th = nil, opts = {}, &block)
      @th_html[@current_col] = th
      th_opts = opts.delete(:th) || {}
      td_opts = opts.delete(:td) || {}
      @th_attributes[@current_col] = deep_merge(opts, th_opts)
      @td_attributes[@current_col] = deep_merge(opts, td_opts)

      @td_html[@row_counter.i] ||= []
      @td_html[@row_counter.i][@current_col] = @parent.capture(&block)

      @current_col += 1
      return nil
    end

    def footer(*args, &block)
      return unless @tfoot.empty?
      if args.size == 1
        rows = [nil]
        opts = args[0]
      elsif args.size == 2
        rows = args[0]
        opts = args[1]
      else
        raise 'greentable footer: number of arguments must be either 1 or two'
      end

      @tfoot << '<tfoot>'
      tr_opts = deep_merge(@defaults_tr, opts.delete(:tr))
      td_opts = deep_merge(opts, opts.delete(:td))
      td_opts = deep_merge(@defaults_td, td_opts)
      TableGroup.new(@parent, rows, {td: td_opts, tr: tr_opts}).process(&block).send(:to_s_tbody_content, @tfoot)
      @tfoot << '</tfoot>'
    end

    def process(&block)
      @records.each do |record|
        @current_col = 0
        block.call(self, record)
        @row_counter.inc
      end
      self
    end

    def to_s
      ret = ""
      return ret if @td_html.empty?
      ret << "<table#{do_attributes(nil,@opts)}>"
      to_s_thead_content(ret)
      ret << "<tbody>"
      to_s_tbody_content(ret)
      ret << "</tbody>"
      ret << @tfoot
      ret << "</table>"
      ret.html_safe
    end

    class TableGroup < Table
      def col(th = nil, opts = {}, &block)
        super(nil, th || {}, &block)
      end
    end

    private

    def to_s_thead_content(ret)
      unless @th_html.compact.empty?
        ret << "<thead>"
        ret << "<tr#{do_attributes(nil, @defaults_tr)}>"
        @th_html.each_with_index do |th,col|
          ret << "<th#{do_attributes(nil, deep_merge(@defaults_th, @th_attributes[col]))}>#{th.is_a?(Proc) ? th.call.to_s : th}</th>"
        end
        ret << "</tr>"
        ret << "</thead>"
      end
    end

    def to_s_tbody_content(ret)
      @row_counter.i.times do |row|
        ret << "<tr#{do_attributes(row, deep_merge(@defaults_tr, @tr_attributes[row]))}>"
        @td_html[row].each_with_index do |td, col|
          ret << "<td#{do_attributes(row, deep_merge(@defaults_td, @td_attributes[col]))}>#{td}</td>"
        end
        ret << "</tr>"
      end
    end

    def do_attributes(i, o)
      instance = i.nil? ? nil : @records[i]
      return "" if o.nil? || o.empty?
      ret = o.map{|k,v| "#{k.is_a?(Proc) ? instance.instance_eval(&k).to_s : k.to_s}=\"#{v.is_a?(Proc) ? instance.instance_eval(&v).to_s : v.to_s}\""}.join(" ").strip
      ret = " " + ret unless ret.empty?
      return ret
    end

    def deep_merge(source_hash, specialized_hash)
      deep_merge!((source_hash||{}).dup, (specialized_hash||{}).dup)
    end

    def deep_merge!(source_hash, specialized_hash)
      #this code is originally from the gem hash-deep-merge, but has been modified slightly
      specialized_hash.each_pair do |rkey, rval|
        if source_hash.has_key?(rkey) then
          lval = source_hash[rkey]
          if rval.is_a?(Hash) and lval.is_a?(Hash) then
            deep_merge(source_hash[rkey], rval)
          elsif rval == source_hash[rkey] then
          elsif rval.is_a?(String) and lval.is_a?(String)
            source_hash[rkey] = "#{lval} #{rval}"
          else
            source_hash[rkey] = rval
          end
        else
          source_hash[rkey] = rval
        end
      end
      return source_hash
    end

  end
end
