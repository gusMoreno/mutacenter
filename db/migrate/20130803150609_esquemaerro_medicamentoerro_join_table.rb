class EsquemaerroMedicamentoerroJoinTable < ActiveRecord::Migration

  def change
    create_table :esquemaerros_medicamentoerros, :id => false do |t|
      t.integer :esquemaerro_id
      t.integer :medicamentoerro_id
    end
  end
end
