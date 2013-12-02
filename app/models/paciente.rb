class Paciente < ActiveRecord::Base
  attr_accessible :dataNasc, :genero, :id_amostra, :nome, :prontuario
  has_many :esquemas
  has_many :genotipagems
  has_many :exames
  validates_uniqueness_of :id_amostra
end
