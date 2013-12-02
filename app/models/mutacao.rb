class Mutacao < ActiveRecord::Base
  attr_accessible :regiao, :sigla
  has_and_belongs_to_many :genotipagems, :uniq => true
  validates_uniqueness_of :sigla, :scope=> [:regiao]
end
