# frozen_string_literal: true

# Ukraine
ukraine = GeoLocation::Country.find_or_create_by!(name: "Ukraine")

kharkiv_oblast = GeoLocation::Region.find_or_create_by!(name: "Kharkiv Oblast", country: ukraine)
GeoLocation::City.find_or_create_by!(name: "Kharkiv", region: kharkiv_oblast)
GeoLocation::City.find_or_create_by!(name: "Izium", region: kharkiv_oblast)

kyiv_oblast = GeoLocation::Region.find_or_create_by!(name: "Kyiv Oblast", country: ukraine)
GeoLocation::City.find_or_create_by!(name: "Kyiv", region: kyiv_oblast)

# Poland
poland = GeoLocation::Country.find_or_create_by!(name: "Poland")

masovian = GeoLocation::Region.find_or_create_by!(name: "Masovian Voivodeship", country: poland)
GeoLocation::City.find_or_create_by!(name: "Warsaw", region: masovian)

puts "GeoLocation seed data loaded successfully!"
