# frozen_string_literal: true

module ::GeoLocation
  class TopicLocationsController < ::ApplicationController
    requires_plugin "discourse-geo-location"
    before_action :ensure_logged_in

    def update
      topic = Topic.find(params[:id])
      guardian.ensure_can_edit!(topic)

      country_id = params[:country_id]
      region_id = params[:region_id]
      city_id = params[:city_id]

      location = TopicLocation.find_or_initialize_by(topic_id: topic.id)
      location.update!(
        country_id: country_id,
        region_id: region_id,
        city_id: city_id
      )

      render json: success_json
    end
  end
end
