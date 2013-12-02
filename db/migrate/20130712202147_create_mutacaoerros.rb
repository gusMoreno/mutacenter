class CreateMutacaoerros < ActiveRecord::Migration
  def change
    create_table :mutacaoerros do |t|
      t.string :regiao
      t.string :sigla

      t.timestamps
    end
  end
end
