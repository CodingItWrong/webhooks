require "link_parser"

module Riverbed
  class LinksController < ApplicationController
    before_action :verify_api_key

    def update
      attributes = {}

      if default_title?(link_params)
        parsed_link = link_parser.process(
          url: link_params["field-values"][url_field_id],
          timeout_seconds: 30
        )
        attributes[title_field_id] = parsed_link.title
        attributes[url_field_id] = parsed_link.canonical
      end

      attributes[saved_at_field_id] = now if link_params["field-values"][saved_at_field_id].blank?
      attributes[read_status_changed_at_field] = now if link_params["field-values"][read_status_changed_at_field].blank?

      render json: attributes
    end

    private

    def api_key = ENV["WEBHOOKS_API_KEY"]

    def api_key_valid?
      provided_header = params["api_key"]
      provided_header == api_key
    end

    def verify_api_key
      head :unauthorized unless api_key_valid?
    end

    def link_params
      params
        .require(:link)
        .permit(
          "field-values": {},
          elements: [:id, attributes: :name]
        )
    end

    def field_id(name)
      link_params[:elements].find { |e|
        e[:attributes][:name] == name
      }[:id]
    end

    def url_field_id = field_id("URL")

    def title_field_id = field_id("Title")

    def saved_at_field_id = field_id("Saved At")

    def read_status_changed_at_field = field_id("Read Status Changed At")

    def link_parser = LinkParser

    def now = Time.zone.now.iso8601(3)

    def default_title?(link_params)
      title_field = link_params["field-values"][title_field_id]
      url_field = link_params["field-values"][url_field_id]

      title_field.blank? || title_field == url_field
    end
  end
end
