# frozen_string_literal: true

class CreateGeoLocationTables < ActiveRecord::Migration[7.0]
  def up
    create_table :countries do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :regions do |t|
      t.string :name, null: false
      t.references :country, null: false, foreign_key: true
      t.timestamps
    end

    create_table :cities do |t|
      t.string :name, null: false
      t.references :region, null: false, foreign_key: true
      t.timestamps
    end

    create_table :topic_locations do |t|
      t.references :topic, null: false, foreign_key: { on_delete: :cascade }
      t.references :country, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.timestamps
    end

    add_index :topic_locations, [:country_id, :region_id, :city_id], name: "idx_topic_locations_hierarchy"
  end

  def down
    drop_table :topic_locations
    drop_table :cities
    drop_table :regions
    drop_table :countries
  end
end
