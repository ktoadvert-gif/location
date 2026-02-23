# frozen_string_literal: true

module ::GeoLocation
  class Country < ActiveRecord::Base
    self.table_name = "countries"
    has_many :regions, class_name: "GeoLocation::Region", dependent: :destroy
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation"

    validates :name, presence: true, uniqueness: true
  end
end
