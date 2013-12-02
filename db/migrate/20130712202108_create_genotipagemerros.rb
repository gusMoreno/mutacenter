class CreateGenotipagemerros < ActiveRecord::Migration
  def change
    create_table :genotipagemerros do |t|
      t.string :localProcedencia
      t.string :dataColeta
      t.string :dataRecep
      t.integer :paciente_id

      t.timestamps
    end
  end
end
