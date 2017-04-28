class RenameStudentSetting < ActiveRecord::Migration[5.0]
  def change
    rename_table("student_settings", "classroom_seating_arrangements")
  end
end
