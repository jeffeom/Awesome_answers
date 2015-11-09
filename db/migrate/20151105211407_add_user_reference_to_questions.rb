class AddUserReferenceToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, index: true, foreign_key: true
    add_column :questions, :abc, :string
  end
end
