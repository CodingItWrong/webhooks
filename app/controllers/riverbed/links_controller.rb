require "link_parser"

module Riverbed
  class LinksController < ApplicationController
    def update
      parsed_link = link_parser.process(
        url: link_params["field-values"][url_field_id],
        timeout_seconds: 30
      )

      # TODO: receive and use field metadata to look up field IDs
      attributes = {
        url_field_id => parsed_link.canonical,
        title_field_id => link_params["field-values"][title_field_id],
        field_id("Saved At") => now,
        field_id("Read Status Changed At") => now
      }
      attributes[title_field_id] = parsed_link.title if default_title?(link_params)

      render json: attributes
    end

    private

    def link_params
      params
        .require(:link)
        .permit(
          "field-values": {},
          elements: [:id, attributes: :name]
        )
    end

    def field_id(name)
      link_params[:elements].find { |e| e[:attributes][:name] == name }[:id]
    end

    def url_field_id = field_id("URL")

    def title_field_id = field_id("Title")

    def link_parser = LinkParser

    def now = Time.zone.now.iso8601

    def default_title?(link_params)
      link_params["field-values"][title_field_id].blank? || link_params["field-values"][title_field_id] == link_params["field-values"][url_field_id]
    end
  end
end
