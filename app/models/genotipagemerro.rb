class Genotipagemerro < ActiveRecord::Base
  attr_accessible :dataColeta, :dataRecep, :localProcedencia, :paciente_id
  belongs_to :pacienteerros , :foreign_key => "paciente_id"
  has_and_belongs_to_many :mutacaoerros, :uniq => true
  validates_uniqueness_of :dataColeta, :scope=> [:paciente_id]
end
