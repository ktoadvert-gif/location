import Service from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class GeoLocationService extends Service {
    getCountries() {
        return ajax("/locations/countries");
    }

    getRegions(countryId) {
        return ajax("/locations/regions", { data: { country_id: countryId } });
    }

    getCities(regionId) {
        return ajax("/locations/cities", { data: { region_id: regionId } });
    }

    updateLocation(topicId, location) {
        return ajax(`/topics/${topicId}/location`, {
            type: "POST",
            data: location,
        });
    }
}
