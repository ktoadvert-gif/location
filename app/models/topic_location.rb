# frozen_string_literal: true

module ::GeoLocation
  class TopicLocation < ActiveRecord::Base
    self.table_name = "topic_locations"
    belongs_to :topic
    belongs_to :country, class_name: "GeoLocation::Country"
    belongs_to :region, class_name: "GeoLocation::Region"
    belongs_to :city, class_name: "GeoLocation::City"

    validates :topic_id, presence: true, uniqueness: true
    validates :country_id, presence: true
    validates :region_id, presence: true
    validates :city_id, presence: true
  end
end
