# frozen_string_literal: true

class CreateGeoLocationTables < ActiveRecord::Migration[7.0]
  def up
    create_table :gl_countries do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :gl_regions do |t|
      t.string :name, null: false
      t.references :gl_country, null: false, foreign_key: { to_table: :gl_countries }
      t.timestamps
    end

    create_table :gl_cities do |t|
      t.string :name, null: false
      t.references :gl_region, null: false, foreign_key: { to_table: :gl_regions }
      t.timestamps
    end

    create_table :gl_topic_locations do |t|
      t.references :topic, null: false, foreign_key: { on_delete: :cascade }
      t.references :gl_country, null: false, foreign_key: { to_table: :gl_countries }
      t.references :gl_region, null: false, foreign_key: { to_table: :gl_regions }
      t.references :gl_city, null: false, foreign_key: { to_table: :gl_cities }
      t.timestamps
    end

    add_index :gl_topic_locations, [:gl_country_id, :gl_region_id, :gl_city_id], name: "idx_gl_topic_locations_hierarchy"
  end

  def down
    drop_table :gl_topic_locations
    drop_table :gl_cities
    drop_table :gl_regions
    drop_table :gl_countries
  end
end
