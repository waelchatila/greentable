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
      @status, @headers, @response = @app.call(env) rescue nil
      @ret = nil
      if env['QUERY_STRING'] =~ /greentable_export=([csv|rtf|xml]+)/i
        request    = Rack::Request.new(env)
        greentable_id = request.params['greentable_id']
        if greentable_id
          format = $1
          body = @response.respond_to?(:body) ? @response.body : @response.join
          doc = Hpricot(body.to_s)
          @ret= ""
          (doc/"##{greentable_id}//tr").each do |tr|
            row = []
            col = 0
            (tr/"/th | /td").each do |x|
              colspan = [(x.attributes['colspan'] || 1).to_i, 1].max
              row[col] = x.to_plain_text
              col += colspan
            end
            CSV.generate_row(row, row.length, @ret)
          end

          filename = request.params['greentable_export_filename'] || "export"

          @headers["Content-Length"] = @ret.length.to_s
          @headers["Content-Type"] = "text/csv"
          @headers["Content-Disposition"] = "attachment; filename=#{filename}.#{format}"
          @headers.delete('ETag')
          @headers.delete('Cache-Control')
        end
      end

      [@status, @headers, self]
    end

    def each(&block)
      block.call(@ret) if @ret
      @response.each(&block)
    end

  end
end
