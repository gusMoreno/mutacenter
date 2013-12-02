class Genotipagem < ActiveRecord::Base
  attr_accessible :dataRecep, :dataColeta ,:localProcedencia , :paciente_id
  belongs_to :pacients , :foreign_key => "paciente_id"
  has_and_belongs_to_many :mutacaos, :uniq => true
  validates_uniqueness_of :dataColeta, :scope=> [:paciente_id]
end
