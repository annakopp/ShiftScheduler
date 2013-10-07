class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :session_token
      t.string :first_name
      t.string :last_name
      t.string :user_type
      t.integer :manager_id
      t.integer :company_id

      t.timestamps
    end
  end
end
