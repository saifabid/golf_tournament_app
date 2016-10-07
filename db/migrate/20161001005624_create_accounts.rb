class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :prefix
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :home_adr1
      t.string :home_adr2
      t.string :home_city
      t.string :home_country
      t.string :home_code
      t.string :home_province
      t.boolean :is_billing
      t.string :bill_adr1
      t.string :bill_adr2
      t.string :bill_city
      t.string :bill_country
      t.string :bill_code
      t.string :bill_province
      t.boolean :gender
      t.date :birth

      t.timestamps
    end
  end
end
