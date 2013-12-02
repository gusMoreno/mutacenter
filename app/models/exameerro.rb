class Exameerro < ActiveRecord::Base
  attr_accessible :data, :paciente_id, :tipo, :valor, :sinal
  belongs_to :pacienteerros , :foreign_key => "paciente_id"
  validates_uniqueness_of :data, :scope => [:valor, :tipo , :paciente_id]
end
