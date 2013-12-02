class Medicamentoerro < ActiveRecord::Base
  attr_accessible :abreviacao, :classe, :nome
  has_and_belongs_to_many :esquemaerros, :uniq => true
  validates_uniqueness_of :abreviacao

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
