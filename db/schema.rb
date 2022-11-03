# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_221_103_213_551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'candidate_vacancies', force: :cascade do |t|
    t.bigint 'candidate_id'
    t.bigint 'vacancy_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['candidate_id'], name: 'index_candidate_vacancies_on_candidate_id'
    t.index ['vacancy_id'], name: 'index_candidate_vacancies_on_vacancy_id'
  end

  create_table 'candidates', force: :cascade do |t|
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'grade_resources', force: :cascade do |t|
    t.integer 'level'
    t.bigint 'grade_id'
    t.bigint 'resource_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['grade_id'], name: 'index_grade_resources_on_grade_id'
    t.index ['resource_id'], name: 'index_grade_resources_on_resource_id'
  end

  create_table 'grades', force: :cascade do |t|
    t.string 'specialization', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'project_resources', force: :cascade do |t|
    t.datetime 'start_date', null: false
    t.datetime 'finish_date', null: false
    t.bigint 'project_id'
    t.bigint 'vacancy_id'
    t.bigint 'resource_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['project_id'], name: 'index_project_resources_on_project_id'
    t.index ['resource_id'], name: 'index_project_resources_on_resource_id'
    t.index ['vacancy_id'], name: 'index_project_resources_on_vacancy_id'
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'start_date'
    t.datetime 'estimated_end_date', null: false
    t.datetime 'end_date'
    t.string 'status'
    t.bigint 'owner_id'
    t.bigint 'manager_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'price'
    t.index ['manager_id'], name: 'index_projects_on_manager_id'
    t.index ['owner_id'], name: 'index_projects_on_owner_id'
  end

  create_table 'skill_resources', force: :cascade do |t|
    t.string 'comment'
    t.integer 'level', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'skills', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'crypted_password', null: false
    t.string 'salt'
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.string 'phone', null: false
    t.string 'post', null: false
    t.string 'api_token'
    t.boolean 'is_resource', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'manager_id'
    t.index ['manager_id'], name: 'index_users_on_manager_id'
  end

  create_table 'vacancies', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'status', null: false
    t.string 'required_grade'
    t.bigint 'project_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['project_id'], name: 'index_vacancies_on_project_id'
  end

  create_table 'vacancy_hrs', force: :cascade do |t|
    t.datetime 'start_date', null: false
    t.datetime 'finish_date', null: false
    t.bigint 'vacancy_id'
    t.bigint 'hr_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['hr_id'], name: 'index_vacancy_hrs_on_hr_id'
    t.index ['vacancy_id'], name: 'index_vacancy_hrs_on_vacancy_id'
  end

  add_foreign_key 'candidate_vacancies', 'candidates'
  add_foreign_key 'candidate_vacancies', 'vacancies'
  add_foreign_key 'grade_resources', 'grades'
  add_foreign_key 'grade_resources', 'users', column: 'resource_id'
  add_foreign_key 'project_resources', 'projects'
  add_foreign_key 'project_resources', 'users', column: 'resource_id'
  add_foreign_key 'project_resources', 'vacancies'
  add_foreign_key 'projects', 'users', column: 'manager_id'
  add_foreign_key 'projects', 'users', column: 'owner_id'
  add_foreign_key 'users', 'users', column: 'manager_id'
  add_foreign_key 'vacancies', 'projects'
  add_foreign_key 'vacancy_hrs', 'users', column: 'hr_id'
  add_foreign_key 'vacancy_hrs', 'vacancies'
end
