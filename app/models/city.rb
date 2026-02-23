# frozen_string_literal: true

module ::GeoLocation
  class City < ActiveRecord::Base
    self.table_name = "cities"
    belongs_to :region, class_name: "GeoLocation::Region"
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation"

    validates :name, presence: true
    validates :region_id, presence: true
  end
end
