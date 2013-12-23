class AddRefererToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :referer, :string
  end
end
