require "rails_helper"
require "link_parser"

RSpec.describe "riverbed links", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:url_field) { {"id" => "1", "attributes" => {"name" => "URL"}} }
  let(:title_field) { {"id" => "2", "attributes" => {"name" => "Title"}} }
  let(:saved_at_field) { {"id" => "3", "attributes" => {"name" => "Saved At"}} }
  let(:read_status_changed_at_field) { {"id" => "4", "attributes" => {"name" => "Read Status Changed At"}} }
  let(:url) { "https://example.com/blog/sample-post-title" }
  let(:headers) { {"Content-Type" => "application/json"} }
  let(:body) {
    {
      "field-values" => field_values,
      "elements" => [
        url_field,
        title_field,
        saved_at_field,
        read_status_changed_at_field
      ]
    }
  }
  let(:response_body) { JSON.parse(response.body) }
  let(:now) { Time.zone.now.iso8601 }

  before(:each) do
    LinkParser.fake!
  end

  around(:each) do |example|
    freeze_time do
      example.run
    end
  end

  def send!
    patch riverbed_link_path(27), params: body.to_json, headers: headers
  end

  context "without a pre-set title" do
    let(:field_values) {
      {
        url_field["id"] => url
      }
    }

    it "returns a record with the retrieved title" do
      send!

      expect(response.status).to eq(200)
      expect(response_body).to eq({
        url_field["id"] => url,
        title_field["id"] => "Sample Post Title",
        saved_at_field["id"] => now,
        read_status_changed_at_field["id"] => now
      })
    end
  end

  context "with a pre-set title" do
    let(:title) { "Pre-Set Title" }
    let(:field_values) {
      {
        url_field["id"] => url,
        title_field["id"] => title
      }
    }

    it "returns a record with the pre-set title" do
      send!

      expect(response.status).to eq(200)
      expect(response_body).to eq({
        url_field["id"] => url,
        title_field["id"] => title,
        saved_at_field["id"] => now,
        read_status_changed_at_field["id"] => now
      })
    end
  end
end
