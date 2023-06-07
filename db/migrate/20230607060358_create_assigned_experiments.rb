class CreateAssignedExperiments < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_experiments do |t|
      t.belongs_to :device, index: true, foreign_key: true, null: false
      t.string :experiment_name, null: false
      t.string :experiment_option, null: false
      t.timestamps

      t.index [:device_id, :experiment_name], unique: true
    end
  end
end
