class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string   :name
      t.string   :url
      t.datetime :locked_until, default: nil
      t.boolean  :processed,    default: false
      t.integer  :accepts,      default: 0
      t.integer  :rejects,      default: 0

      t.timestamps
    end

    add_index :reviews, [:processed, :locked_until]
  end
end
