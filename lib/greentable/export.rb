require 'csv'
require 'nokogiri'

module Greentable
  class Export
    def initialize(app, *args, &block)
      @app = app
      @env = nil
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      status, headers, response = @app.call(env)
      greentable_export = (env['QUERY_STRING'] || '').scan(/greentable_export=([csv|print]+)/i)[0][0] rescue nil
      if greentable_export
        request    = Rack::Request.new(env)
        greentable_id = request.params['greentable_id']
        if greentable_id
          body = response.respond_to?(:body) ? response.body : response.join
          doc = Nokogiri(body.to_s)
          if greentable_export == 'csv'
            ret= ""
            (doc/"##{greentable_id}//tr").each do |tr|
              row = []
              col = 0
              (tr/"./th | ./td").each do |x|
                colspan = (x.attributes['colspan'] || 1).to_i
                colspan = [colspan,1].max
                row[col] = (x.inner_text || '').strip
                col += colspan
              end
              CSV.generate(ret, :encoding => 'UTF-8'){ |csv| csv << row }
            end
            filename = request.params['greentable_export_filename'] || "export"
            headers["Content-Length"] = ret.length.to_s
            headers["Content-Type"] = "text/csv"
            headers["Content-Disposition"] = "attachment; filename=#{filename}.#{greentable_export}"
            headers.delete('ETag')
            headers.delete('Cache-Control')
            response = [ret]
          elsif greentable_export == 'print'
            table_node = doc.css("##{greentable_id}").remove
            body = doc.css('body')[0]
            js_print = "<script>window.onload = function() { window.focus(); window.print(); }</script>"
            body.inner_html = table_node.to_html + js_print
            response = [doc.to_html]
          end
        end
      end

      [status, headers, response]
    end

    #def each(&block)
    #  block.call(ret) if ret
    #  response.each(&block)
    #end

  end
end
