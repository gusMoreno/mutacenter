class CreateMedicamentoerros < ActiveRecord::Migration
  def change
    create_table :medicamentoerros do |t|
      t.string :nome
      t.string :abreviacao
      t.string :classe

      t.timestamps
    end
  end
end
