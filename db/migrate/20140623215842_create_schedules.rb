class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.text :name
      t.datetime :active
      t.integer :send_count

      t.string :klass # RandomSchedule/LatestSchedule/StartFromSchedule
      t.hstore :settings

      t.integer :destination_ids, array: true, default: []

      t.timestamps
    end
    add_index :schedules, :user_id

    create_table :destinations do |t|
      t.integer :user_id
      t.text :name

      t.string :klass # Email/IRC/HipChat/Slack
      t.hstore :options

      t.timestamps
    end
    add_index :destinations, :user_id

    create_table :outbound_comics do |t|
      t.integer :schedule_id
      t.integer :comic_number
      t.datetime :sent_at

      t.integer :destination_ids, array: true, default: []

      t.timestamps
    end
    add_index :outbound_comics, :schedule_id

    add_index :favourites, :user_id
    add_index :favourites, [:favable_type, :favable_id]
    add_index :comics, :number
  end
end
