# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130803151420) do

  create_table "esquemaerros", :force => true do |t|
    t.string   "DataIni"
    t.string   "DataFim"
    t.integer  "paciente_id"
    t.string   "atual"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "esquemaerros_medicamentoerros", :id => false, :force => true do |t|
    t.integer "esquemaerro_id"
    t.integer "medicamentoerro_id"
  end

  create_table "esquemas", :force => true do |t|
    t.string   "DataIni"
    t.string   "DataFim"
    t.integer  "paciente_id"
    t.string   "atual"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "esquemas_medicamentos", :id => false, :force => true do |t|
    t.integer "esquema_id"
    t.integer "medicamento_id"
  end

  create_table "exameerros", :force => true do |t|
    t.string   "tipo"
    t.string   "data"
    t.integer  "valor"
    t.integer  "paciente_id"
    t.string   "sinal"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "exames", :force => true do |t|
    t.string   "tipo"
    t.string   "data"
    t.integer  "valor"
    t.integer  "paciente_id"
    t.string   "sinal"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "genotipagemerros", :force => true do |t|
    t.string   "localProcedencia"
    t.string   "dataColeta"
    t.string   "dataRecep"
    t.integer  "paciente_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "genotipagemerros_mutacaoerros", :id => false, :force => true do |t|
    t.integer "genotipagemerro_id"
    t.integer "mutacaoerro_id"
  end

  create_table "genotipagems", :force => true do |t|
    t.string   "localProcedencia"
    t.string   "dataColeta"
    t.string   "dataRecep"
    t.integer  "paciente_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "genotipagems_mutacaos", :id => false, :force => true do |t|
    t.integer "genotipagem_id"
    t.integer "mutacao_id"
  end

  create_table "medicamentoerros", :force => true do |t|
    t.string   "nome"
    t.string   "abreviacao"
    t.string   "classe"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "medicamentos", :force => true do |t|
    t.string   "nome"
    t.string   "abreviacao"
    t.string   "classe"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mutacaoerros", :force => true do |t|
    t.string   "regiao"
    t.string   "sigla"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mutacaos", :force => true do |t|
    t.string   "regiao"
    t.string   "sigla"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pacienteerros", :force => true do |t|
    t.integer  "id_amostra"
    t.string   "nome"
    t.string   "dataNasc"
    t.string   "prontuario"
    t.string   "genero"
    t.string   "antigo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pacientes", :force => true do |t|
    t.integer  "id_amostra"
    t.string   "nome"
    t.string   "dataNasc"
    t.string   "prontuario"
    t.string   "genero"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
