class CreateExames < ActiveRecord::Migration
  def change
    create_table :exames do |t|
      t.string :tipo
      t.string :data
      t.integer :valor
      t.integer :paciente_id
      t.string :sinal

      t.timestamps
    end
  end
end
