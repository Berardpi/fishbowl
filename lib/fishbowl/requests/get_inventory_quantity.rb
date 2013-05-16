require 'nokogiri'
require 'date'
require 'fishbowl/objects/part'
require 'fishbowl/requests/base_request'

module Fishbowl::Requests

  class GetInventoryQuantity < BaseRequest

    attr_accessor :part_number, :last_modified_from, :last_modified_to

    def compose
      validate
      envelope(Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.InvQtyRq {
            xml.PartNum @part_number
            xml.LastModifiedFrom @last_modified_from unless @last_modified_from.nil?
            xml.LastModifiedTo @last_modified_to unless @last_modified_to.nil?
          }
        }
      end)
    end

  protected

    def validate
      raise 'Missing field: part_number' if @part_number.nil?
    end

    def distill(response_doc)
      Fishbowl::Objects::Part.from_xml(response_doc.at_xpath('//Part'))
    end

  end

end