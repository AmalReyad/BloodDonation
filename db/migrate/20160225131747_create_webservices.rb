class CreateWebservices < ActiveRecord::Migration
  def change
    create_table :webservices do |t|

      t.timestamps null: false
    end
  end
end
