module SeoReport::Representation
  class Cli < Base
    def represent
      url = data[:requests].first[:request_url]
      puts "#{white_color('URL: ')}#{url}"
      separator
      data[:requests].each do |request|
        provide_response_data(request)
      end
    end

    protected
    def provide_response_data(request)
      code = request[:response_code]
      if code == 200
        provide_html_response(request)
      elsif code >= 300 && code < 400
        provide_redirection_response(request)
      end
    end

    def provide_html_response(request)
      code = request[:response_code]
      separator if multiple_requests?
      puts "#{white_color('Status: ')}#{color_for_code(code)}"
      canonical =
        if request[:canonical] == request[:request_url]
          green_color(request[:canonical], bold: true)
        else
          red_color(request[:canonical], bold: true)
        end
      puts "#{white_color('Canonical: ')}#{canonical}"
      puts "#{white_color('Title: ')}#{request[:title]}"
      puts "#{white_color('Description: ')}#{request[:description]}"
      provide_robots_response(request)
      provide_twitter_response(request)
      provide_opengraph_response(request)
    end

    def provide_redirection_response(request)
      code = request[:response_code]
      location =
        if request[:location] == request[:request_url]
          red_color(request[:location], bold: true)
        else
          request[:location]
        end
      if data[:requests].length > 1
        puts "#{white_color('redirect')} with #{blue_color(code, bold: true)} to #{white_color(location)}"
      else
        puts "#{white_color('Status: ')}#{color_for_code(code)}"
        puts "#{white_color('Location: ')}#{location}"
      end
    end

    def provide_robots_response(request)
      literal_tags = request[:robots].dup
      tags = literal_tags.map(&:downcase)
      puts "#{white_color('Robots: ')}"
      no_robots_tag = tags.find { |t| t.match(/.*no(?:index|follow).*/) }
      if !tags.include?("all") && no_robots_tag
        literal_tags.delete_at(tags.find_index(no_robots_tag))
        puts "  - #{red_color(no_robots_tag, bold: true)}"
      elsif !tags.include?("all") && !tags.any? { |t| t.match(/index|follow/) }
        puts "  - index, follow (#{white_color('default')})"
      end
      literal_tags.each do |robot_tag|
        puts "  - #{robot_tag}"
      end
    end

    def provide_twitter_response(request)
      twitter = request[:twitter]
      if any_data_in_hash?(twitter)
        puts "#{white_color('Twitter-Card: ')}"
        puts "  #{white_color('Card: ')}#{twitter[:card]}"
        puts "  #{white_color('Domain: ')}#{twitter[:domain]}"
        puts "  #{white_color('Title: ')}#{twitter[:title]}"
        puts "  #{white_color('Description: ')}#{twitter[:description]}"
      else
        puts "#{white_color('Twitter-Card:')} no matching data present in response"
      end
    end

    def provide_opengraph_response(request)
      opengraph = request[:og]
      if any_data_in_hash?(opengraph)
        puts "#{white_color('OpenGraph (Facebook): ')}"
        puts "  #{white_color('type: ')}#{opengraph[:type]}"
        puts "  #{white_color('site_name: ')}#{opengraph[:site_name]}"
        puts "  #{white_color('Title: ')}#{opengraph[:title]}"
        puts "  #{white_color('Description: ')}#{opengraph[:description]}"
        puts "  #{white_color('URL: ')}#{opengraph[:url]}"
        puts "  #{white_color('image: ')}#{opengraph[:image]}"
      else
        puts "#{white_color('OpenGraph (Facebook):')} no matching data present in response"
      end
    end

    def multiple_requests?
      data[:requests].length > 1
    end

    def separator
      puts "#{white_color('----------------------------------------')}"
    end

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
