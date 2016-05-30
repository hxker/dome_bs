class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :username
      t.integer :gender
      t.integer :age
      t.integer :school_id
      t.integer :sk_station
      t.integer :standby_school
      t.string :student_code # 学籍号
      t.string :identity_card, length: {in: 18} # 身份证
      t.string :nationality # 民族
      t.string :grade # 年级
      t.integer :bj # 班级
      t.string :autograph # 个性签名
      t.string :address
      t.string :roles
      t.integer :district_id
      t.date :birthday
      t.string :address
      t.string :teacher_no
      t.string :certificate

      t.timestamps
    end
    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :school_id
    add_index :user_profiles, :gender
    add_index :user_profiles, :grade
    add_index :user_profiles, :student_code
    add_index :user_profiles, :identity_card
    add_index :user_profiles, :district_id
    add_index :user_profiles, :roles
    add_index :user_profiles, :sk_station
  end
end
