class EsquemaMedicamentoJoinTable < ActiveRecord::Migration

  def change
    create_table :esquemas_medicamentos, :id => false do |t|
      t.integer :esquema_id
      t.integer :medicamento_id
    end
  end
end
