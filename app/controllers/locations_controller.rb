# frozen_string_literal: true

module ::GeoLocation
  class LocationsController < ::ApplicationController
    requires_plugin "discourse-geo-location"
    skip_before_action :check_xaxis_csrf_token

    def countries
      render json: Country.order(:name).all
    end

    def regions
      params.require(:country_id)
      render json: Region.where(country_id: params[:country_id]).order(:name).all
    end

    def cities
      params.require(:region_id)
      render json: City.where(region_id: params[:region_id]).order(:name).all
    end
  end
end
