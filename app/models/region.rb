# frozen_string_literal: true

module ::GeoLocation
  class Region < ActiveRecord::Base
    self.table_name = "gl_regions"
    belongs_to :country, class_name: "GeoLocation::Country", foreign_key: "gl_country_id"
    has_many :cities, class_name: "GeoLocation::City", foreign_key: "gl_region_id", dependent: :destroy
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation", foreign_key: "gl_region_id"

    validates :name, presence: true
    validates :gl_country_id, presence: true
  end
end
