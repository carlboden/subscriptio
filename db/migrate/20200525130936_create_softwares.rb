class CreateSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :softwares do |t|
      t.string :name
      t.string :url
      t.string :category
      t.string :demo_url

      t.timestamps
    end
  end
end
