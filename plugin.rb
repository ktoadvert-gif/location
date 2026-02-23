# frozen_string_literal: true

# name: discourse-geo-location
# about: Geo-location system for topics (Country -> Region -> City)
# version: 0.1
# authors: Antigravity
# url: https://github.com/antigravity/discourse-geo-location

enabled_site_setting :geo_location_enabled

module ::GeoLocation
  PLUGIN_NAME = "discourse-geo-location"
end

register_asset "stylesheets/common/geo-location.scss"

after_initialize do
  %w[
    ../app/models/country.rb
    ../app/models/region.rb
    ../app/models/city.rb
    ../app/models/topic_location.rb
    ../app/controllers/locations_controller.rb
    ../app/controllers/topic_locations_controller.rb
  ].each { |path| load File.expand_path(path, __FILE__) }

  # Routes
  Discourse::Application.routes.append do
    get "/locations/countries" => "geo_location/locations#countries"
    get "/locations/regions" => "geo_location/locations#regions"
    get "/locations/cities" => "geo_location/locations#cities"
    post "/topics/:id/location" => "geo_location/topic_locations#update"
  end

  # TopicQuery Extension for filtering
  reloadable_patch do
    class ::TopicQuery
      def list_filter_by_location(topics, options)
        if options[:country_id].present?
          topics = topics.joins("INNER JOIN topic_locations ON topic_locations.topic_id = topics.id")
          topics = topics.where("topic_locations.country_id = ?", options[:country_id])
          
          if options[:region_id].present?
            topics = topics.where("topic_locations.region_id = ?", options[:region_id])
          end
          
          if options[:city_id].present?
            topics = topics.where("topic_locations.city_id = ?", options[:city_id])
          end
        end
        topics
      end
    end

    # Hook into TopicQuery to apply filters
    # This is a common pattern in Discourse plugins
    TopicQuery.add_custom_filter(:location) do |results, topic_query|
      topic_query.list_filter_by_location(results, topic_query.options)
    end
  end

  # Add location info to Topic serializers
  add_to_serializer(:topic_view, :location) do
    GeoLocation::TopicLocation.find_by(topic_id: object.topic.id)
  end

  add_to_serializer(:topic_list_item, :location) do
    GeoLocation::TopicLocation.find_by(topic_id: object.id)
  end

  # Include location in TopicList preloading to avoid N+1
  if TopicList.respond_to?(:preloaded_custom_fields)
    # We are using a table, so we might need to handle preloading differently
    # But for simplicity in this version, we'll use a direct join or simple find_by
    # In a production environment, we'd use .includes(:topic_location)
  end
end
