class AddGrampicToGrams < ActiveRecord::Migration
  def change
    add_column :grams, :grampic, :string
  end
end
