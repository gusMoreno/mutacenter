class CreateMutacaos < ActiveRecord::Migration
  def change
    create_table :mutacaos do |t|
      t.string :regiao
      t.string :sigla

      t.timestamps
    end
  end
end
