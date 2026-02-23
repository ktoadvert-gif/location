import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class GeoLocationComposer extends Component {
    @service geoLocationApi;
    @service composer;

    @tracked countries = [];
    @tracked regions = [];
    @tracked cities = [];

    @tracked selectedCountryId = null;
    @tracked selectedRegionId = null;
    @tracked selectedCityId = null;

    constructor() {
        super(...arguments);
        this.loadCountries();

        // If editing, we would load existing data here
        // For now, we focus on creation
    }

    async loadCountries() {
        this.countries = await this.geoLocationApi.getCountries();
    }

    @action
    async onCountryChange(countryId) {
        this.selectedCountryId = countryId;
        this.selectedRegionId = null;
        this.selectedCityId = null;
        this.regions = [];
        this.cities = [];

        if (countryId) {
            this.regions = await this.geoLocationApi.getRegions(countryId);
        }
        this.updateComposer();
    }

    @action
    async onRegionChange(regionId) {
        this.selectedRegionId = regionId;
        this.selectedCityId = null;
        this.cities = [];

        if (regionId) {
            this.cities = await this.geoLocationApi.getCities(regionId);
        }
        this.updateComposer();
    }

    @action
    onCityChange(cityId) {
        this.selectedCityId = cityId;
        this.updateComposer();
    }

    updateComposer() {
        const model = this.args.model; // composer model
        if (model) {
            model.set("geo_location_data", {
                country_id: this.selectedCountryId,
                region_id: this.selectedRegionId,
                city_id: this.selectedCityId,
            });

            // Validation: all fields required
            const isValid = !!(this.selectedCountryId && this.selectedRegionId && this.selectedCityId);
            model.set("geo_location_valid", isValid);
        }
    }
}
