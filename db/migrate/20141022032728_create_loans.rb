class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :amount
      t.integer :year
      t.decimal :interest

      t.timestamps
    end
  end
end
