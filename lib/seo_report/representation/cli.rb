module SeoReport::Representation
  class Cli
    attr_reader :report

    def self.represent_with_report_for(url)
      report = SeoReport::Report.new(url)
      report.produce
      new(report).represent
    end

    def initialize(report)
      @report = report
    end

    def represent
      r = report.report
      puts "#{white_color('URL: ')}#{r[:request_url]}"
      puts "#{white_color('Status: ')}#{color_for_code(r[:response_code])}"
      if r[:response_code] == 200
        provide_html_response
      elsif r[:response_code] >= 300 && r[:response_code] < 400
        provide_redirection_response
      end
    end

    def provide_html_response
      r = report.report
      canonical =
        if r[:canonical] == r[:request_url]
          green_color(r[:canonical], bold: true)
        else
          red_color(r[:canonical], bold: true)
        end
      puts "#{white_color('Canonical: ')}#{canonical}"
      puts "#{white_color('Title: ')}#{r[:title]}"
      puts "#{white_color('Description: ')}#{r[:description]}"
      puts "#{white_color('Robots: ')}"
      r[:robots].each do |robot_tag|
        puts "  - #{robot_tag}"
      end
      provide_twitter_response
      provide_opengraph_response
    end

    def provide_redirection_response
      r = report.report
      location =
        if r[:location] == r[:request_url]
          red_color(r[:location], bold: true)
        else
          r[:location]
        end
      puts "#{white_color('Location: ')}#{location}"
    end

    def provide_twitter_response
      r = report.report[:twitter]
      puts "#{white_color('Twitter-Card: ')}"
      puts "  #{white_color('Card: ')}#{r[:card]}"
      puts "  #{white_color('Domain: ')}#{r[:domain]}"
      puts "  #{white_color('Title: ')}#{r[:title]}"
      puts "  #{white_color('Description: ')}#{r[:description]}"
    end

    def provide_opengraph_response
      r = report.report[:og]
      puts "#{white_color('OpenGraph (Facebook): ')}"
      puts "  #{white_color('type: ')}#{r[:type]}"
      puts "  #{white_color('site_name: ')}#{r[:site_name]}"
      puts "  #{white_color('Title: ')}#{r[:title]}"
      puts "  #{white_color('Description: ')}#{r[:description]}"
      puts "  #{white_color('URL: ')}#{r[:url]}"
      puts "  #{white_color('image: ')}#{r[:image]}"
    end

    protected
    def white(text, io = $stdout)
      io.print(white_color(text))
    end

    def white_color(text, bold: true)
      color_with_code(text, code: 37, bold: bold)
    end

    def green_color(text, bold: false)
      color_with_code(text, code: 32, bold: bold)
    end

    def red_color(text, bold: false)
      color_with_code(text, code: 31, bold: bold)
    end

    def blue_color(text, bold: false)
      color_with_code(text, code: 34, bold: bold)
    end

    def color_with_code(text, code:, bold: false)
      bold_val = bold ? 1 : 0
      "\033[#{bold_val};#{code}m#{text}\033[0m"
    end

    def color_for_code(code)
      if code == 200
        green_color(code, bold: true)
      elsif code > 200 && code < 300
        white_color(code, bold: false)
      elsif code >= 300 && code < 400
        blue_color(code, bold: true)
      elsif code >= 400 && code < 500
        red_color(code, bold: false)
      else
        red_color(code, bold: true)
      end
    end
  end
end
