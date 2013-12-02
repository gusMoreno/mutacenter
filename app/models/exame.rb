class Exame < ActiveRecord::Base
  attr_accessible :tipo, :data, :valor , :paciente_id, :sinal
  belongs_to :pacients , :foreign_key => "paciente_id"
  validates_uniqueness_of :data, :scope => [:valor, :tipo , :paciente_id]
end
