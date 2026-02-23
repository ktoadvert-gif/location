# frozen_string_literal: true

module ::GeoLocation
  class City < ActiveRecord::Base
    self.table_name = "gl_cities"
    belongs_to :region, class_name: "GeoLocation::Region", foreign_key: "gl_region_id"
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation", foreign_key: "gl_city_id"

    validates :name, presence: true
    validates :gl_region_id, presence: true
  end
end
