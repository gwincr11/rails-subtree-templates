class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :login, null: false
      t.string :email, null: false
      t.string :github_authentication_token, null: false
      t.integer :github_id, null: false

      t.timestamps
    end
  end
end
