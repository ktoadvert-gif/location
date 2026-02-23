import { withPluginApi } from "discourse/lib/plugin-api";
import { ajax } from "discourse/lib/ajax";

export default {
    name: "discourse-geo-location",

    initialize() {
        withPluginApi("0.1", (api) => {
            // Validate composer before save
            api.composerBeforeSave((composer) => {
                if (!composer.get("geo_location_valid") && composer.get("composerAction") !== "edit") {
                    composer.set("errors", [I18n.t("js.geo_location.required_error")]);
                    return false;
                }
            });

            // After topic creation, save location
            api.onAppEvent("composer:topic-created", (data) => {
                const composer = data.composerModel;
                const locationData = composer.get("geo_location_data");

                if (locationData && locationData.city_id) {
                    ajax(`/topics/${data.post.topic_id}/location`, {
                        type: "POST",
                        data: locationData,
                    });
                }
            });

            // Handle editing
            api.onAppEvent("composer:opened", (data) => {
                if (data.composerModel.get("composerAction") === "edit") {
                    const topic = data.composerModel.get("topic");
                    if (topic && topic.location) {
                        data.composerModel.set("geo_location_data", topic.location);
                        data.composerModel.set("geo_location_valid", true);
                    }
                }
            });
        });
    },
};
