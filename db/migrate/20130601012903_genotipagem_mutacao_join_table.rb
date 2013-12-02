class GenotipagemMutacaoJoinTable < ActiveRecord::Migration

  def change
    create_table :genotipagems_mutacaos, :id => false do |t|
      t.integer :genotipagem_id
      t.integer :mutacao_id
    end
  end

end
