class CreateGenotipagems < ActiveRecord::Migration
  def change
    create_table :genotipagems do |t|
      t.string :localProcedencia
      t.string :dataColeta
      t.string :dataRecep
      t.integer :paciente_id

      t.timestamps
    end
  end
end

#TODO mudei migrates genotipagems, pacientes, esquemas, exames data date para string
#TODO passar o mostra busca para o kenzo e o static_pages_helper (que mudei para diminuir os rollbacks)
#TODO colocar validate_uniqueness_of id_amostra
#TODO validates_uniqueness_of :DataFim, :scope=>[:paciente_id] no esquema
#TODO validates_uniqueness_of :dataColeta, :scope=> [:paciente_id] no genotipagem