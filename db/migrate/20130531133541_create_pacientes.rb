class CreatePacientes < ActiveRecord::Migration
  def change
    create_table :pacientes do |t|
      t.integer :id_amostra
      t.string :nome
      t.string :dataNasc
      t.string :prontuario
      t.string :genero

      t.timestamps
    end
  end
end
