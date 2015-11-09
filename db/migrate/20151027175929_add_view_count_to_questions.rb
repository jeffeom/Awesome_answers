# bin/rails g migration add_view_count_to_questions

class AddViewCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :view_count, :integer
  end
end
