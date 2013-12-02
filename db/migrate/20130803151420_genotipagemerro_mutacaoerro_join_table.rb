class GenotipagemerroMutacaoerroJoinTable < ActiveRecord::Migration

  def change
    create_table :genotipagemerros_mutacaoerros, :id => false do |t|
      t.integer :genotipagemerro_id
      t.integer :mutacaoerro_id
    end
  end
end
