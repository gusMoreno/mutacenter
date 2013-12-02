class CreateMedicamentos < ActiveRecord::Migration
  def change
    create_table :medicamentos do |t|
      t.string :nome
      t.string :abreviacao
      t.string :classe

      t.timestamps
    end
  end
end
