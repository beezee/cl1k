class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :target
      t.string :slug
      t.integer :user_id

      t.timestamps
    end
		add_index :redirects, :slug, unique: true
		add_index :redirects, [:target, :user_id], unique: true
  end
end
