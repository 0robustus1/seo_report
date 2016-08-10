module SeoReport::Extractions
  module Microdata
    def extract_microdata(document)
      MicrodataExtractor.new(document).extract!
    end

    class MicrodataExtractor
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def extract!
        document.at_xpath('/html/body').children.each do |child|
          process(child)
        end
        {
          microdata: {
            elements: result_set,
            errors: errors,
          }
        }
      end

      protected
      def process(child, level = 1)
        if microdata_element?(child)
          process_microdata(child, level)
        else
          child.children.each { |c| process(c, level) }
        end
      end

      def process_microdata(child, level)
        if microdata_scope?(child)
          push_scope(child)
          child.children.each { |c| process(c, level + 1) }
          scope = wrap_scope!
          store_as_dangling_if_necessary!(child, scope, level)
          result_set << scope if level == 1
        else
          provide_data_for_itemprop(child)
          child.children.each { |c| process(c, level) }
        end
      end

      def store_as_dangling_if_necessary!(element, scope, level)
        itemprop = element["itemprop"]
        is_top_level = level == 1
        is_assigned_with_itemprop = !itemprop.nil? && !itemprop.empty?
        if !is_top_level && !is_assigned_with_itemprop
          (current_scope[:@dangling_children] ||= []) << scope
        end
      end

      def provide_data_for_itemprop(element)
        data = microdata_itemprop_value(element)
        if current_scope
          current_scope[element["itemprop"]] = data
        else
          error = {
            tag: element.name,
            itemprop: element["itemprop"],
            value: data,
          }
          error.merge!(id: element["id"]) if element["id"]
          (errors[:scopeless_elements] ||= []) << error
        end
      end

      def push_scope(element)
        new_scope = {
          type: element["itemtype"]
        }
        if microdata_prop?(element)
          current_scope[element["itemprop"]] = new_scope
        end
        scopes.push(new_scope)
      end

      def wrap_scope!
        scopes.pop
      end

      def current_scope
        scopes.last
      end

      def scopes
        @scopes ||= []
      end

      def result_set
        @result_set ||= []
      end

      def errors
        @errors ||= {}
      end

      def microdata_element?(element)
        %w(itemscope itemtype itemprop).
          any? { |attr| element.has_attribute?(attr) }
      end

      def microdata_scope?(element)
        element.has_attribute?("itemscope")
      end

      def microdata_prop?(element)
        element.has_attribute?("itemprop")
      end

      def microdata_itemprop_value(element)
        if element.name == "meta"
          element["content"]
        elsif %w(audio embed iframe img source track video).include?(element.name)
          element["src"]
        elsif %w(a area link).include?(element.name)
          element["href"]
        elsif element.name == "object"
          element["data"]
        elsif %w(data meter).include?(element.name)
          element["value"]
        else
          element.text
        end
      end
    end

    SeoReport::Report.register_extraction(:html, Microdata, :extract_microdata)
  end
end
