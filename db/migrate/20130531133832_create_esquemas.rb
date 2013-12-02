class CreateEsquemas < ActiveRecord::Migration
  def change
    create_table :esquemas do |t|
      t.string :DataIni
      t.string :DataFim
      t.integer :paciente_id
      t.string :atual

      t.timestamps
    end
  end
end
