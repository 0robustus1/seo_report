$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'seo_report'
require "webmock/rspec"

RSpec::Matchers.define :be_registered_with do |*expected|
  method_name = expected.first
  response_type = expected.last[:for] || :html
  match do |module_class|
    expect(SeoReport::Report.ancestors).to include(module_class)
    expect(SeoReport::Report.instance_methods).to include(method_name)
    expect(SeoReport::Report.extractions.has_key?(response_type)).to be_truthy
    expect(SeoReport::Report.extractions[response_type]).to include(method_name)
  end
end

class TestResponseRenderer < OpenStruct
  def self.render_from_hash(template, hash = {})
    new(hash || {}).render(template)
  end

  def render(template)
    ERB.new(template).result(binding)
  end
end

def render_template(content = {})
  template_file_name = "spec/fixtures/response-template.html.erb"
  @template ||= File.read(template_file_name)
  TestResponseRenderer.render_from_hash(@template, content)
end
