class Pacienteerro < ActiveRecord::Base
  attr_accessible :dataNasc, :genero, :id_amostra, :nome, :prontuario
  has_many :esquemaerros
  has_many :genotipagemerros
  has_many :exameerros
  validates_uniqueness_of :id_amostra
end
