# frozen_string_literal: true

module ::GeoLocation
  class Region < ActiveRecord::Base
    self.table_name = "regions"
    belongs_to :country, class_name: "GeoLocation::Country"
    has_many :cities, class_name: "GeoLocation::City", dependent: :destroy
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation"

    validates :name, presence: true
    validates :country_id, presence: true
  end
end
