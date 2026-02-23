import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { next } from "@ember/runloop";

export default class GeoLocationFilter extends Component {
    @service geoLocationApi;
    @service router;

    @tracked countries = [];
    @tracked regions = [];
    @tracked cities = [];

    @tracked selectedCountryId = null;
    @tracked selectedRegionId = null;
    @tracked selectedCityId = null;

    constructor() {
        super(...arguments);
        this.loadCountries();

        // Initialize from URL params if present
        const params = this.router.currentRoute.queryParams;
        if (params.country_id) {
            this.selectedCountryId = params.country_id;
            this.loadRegions(params.country_id).then(() => {
                if (params.region_id) {
                    this.selectedRegionId = params.region_id;
                    this.loadCities(params.region_id).then(() => {
                        if (params.city_id) {
                            this.selectedCityId = params.city_id;
                        }
                    });
                }
            });
        }
    }

    async loadCountries() {
        this.countries = await this.geoLocationApi.getCountries();
    }

    async loadRegions(countryId) {
        this.regions = await this.geoLocationApi.getRegions(countryId);
    }

    async loadCities(regionId) {
        this.cities = await this.geoLocationApi.getCities(regionId);
    }

    @action
    async onCountryChange(countryId) {
        this.selectedCountryId = countryId;
        this.selectedRegionId = null;
        this.selectedCityId = null;
        this.regions = [];
        this.cities = [];

        if (countryId) {
            await this.loadRegions(countryId);
        }
        this.applyFilter();
    }

    @action
    async onRegionChange(regionId) {
        this.selectedRegionId = regionId;
        this.selectedCityId = null;
        this.cities = [];

        if (regionId) {
            await this.loadCities(regionId);
        }
        this.applyFilter();
    }

    @action
    onCityChange(cityId) {
        this.selectedCityId = cityId;
        this.applyFilter();
    }

    applyFilter() {
        const queryParams = {
            country_id: this.selectedCountryId,
            region_id: this.selectedRegionId,
            city_id: this.selectedCityId,
        };

        // Update URL which will trigger TopicQuery on backend if handled
        this.router.transitionTo({ queryParams });
    }
}
