class Esquema < ActiveRecord::Base
  attr_accessible :DataFim, :DataIni, :atual , :paciente_id
  belongs_to :pacientes , :foreign_key => "paciente_id"
  #has_many :esquemas_medicamentos
 # has_many :medicamentos , :through => :esquemas_medicamentos

  has_and_belongs_to_many :medicamentos, :uniq => true
  validates_uniqueness_of :DataFim, :scope=>[:paciente_id, :DataIni]
end
