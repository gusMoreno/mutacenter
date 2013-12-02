class Esquemaerro < ActiveRecord::Base
  attr_accessible :DataFim, :DataIni, :atual, :paciente_id
  belongs_to :pacienteerros , :foreign_key => "paciente_id"

  has_and_belongs_to_many :medicamentoerros, :uniq => true
  validates_uniqueness_of :DataFim, :scope=>[:paciente_id, :DataIni]
end
