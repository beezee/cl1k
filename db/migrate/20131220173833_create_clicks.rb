class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :redirect_id
      t.string :user_agent
      t.string :browser
      t.string :version
      t.string :platform
      t.float :latitude
      t.float :longitude
      t.string :ip_address
      t.integer :city_id

      t.timestamps
    end
		add_index :clicks, :redirect_id
		add_index :clicks, :city_id
  end
end
