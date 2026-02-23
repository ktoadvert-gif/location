# frozen_string_literal: true

module ::GeoLocation
  class Country < ActiveRecord::Base
    self.table_name = "gl_countries"
    has_many :regions, class_name: "GeoLocation::Region", foreign_key: "gl_country_id", dependent: :destroy
    has_many :topic_locations, class_name: "GeoLocation::TopicLocation", foreign_key: "gl_country_id"

    validates :name, presence: true, uniqueness: true
  end
end
