class CreatePacienteerros < ActiveRecord::Migration
  def change
    create_table :pacienteerros do |t|
      t.integer :id_amostra
      t.string :nome
      t.string :dataNasc
      t.string :prontuario
      t.string :genero
      t.string :antigo #flag pra marcar se já foi exportado

      t.timestamps
    end
  end
end
