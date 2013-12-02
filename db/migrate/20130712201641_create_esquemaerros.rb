class CreateEsquemaerros < ActiveRecord::Migration
  def change
    create_table :esquemaerros do |t|
      t.string :DataIni
      t.string :DataFim
      t.integer :paciente_id
      t.string :atual

      t.timestamps
    end
  end
end
