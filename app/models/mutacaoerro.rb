class Mutacaoerro < ActiveRecord::Base
  attr_accessible :regiao, :sigla
  has_and_belongs_to_many :genotipagemerross, :uniq => true
  validates_uniqueness_of :sigla, :scope=> [:regiao]
end
