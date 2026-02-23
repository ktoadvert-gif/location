# frozen_string_literal: true

module ::GeoLocation
  class TopicLocation < ActiveRecord::Base
    self.table_name = "gl_topic_locations"
    belongs_to :topic
    belongs_to :country, class_name: "GeoLocation::Country", foreign_key: "gl_country_id"
    belongs_to :region, class_name: "GeoLocation::Region", foreign_key: "gl_region_id"
    belongs_to :city, class_name: "GeoLocation::City", foreign_key: "gl_city_id"

    validates :topic_id, presence: true, uniqueness: true
    validates :gl_country_id, presence: true
    validates :gl_region_id, presence: true
    validates :gl_city_id, presence: true
  end
end
