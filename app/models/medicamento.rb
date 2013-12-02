class Medicamento < ActiveRecord::Base
  attr_accessible :abreviacao, :nome , :classe
 # has_many :esquemas_medicamentos
 # has_many :esquemas , :through => :esquemas_medicamentos
  has_and_belongs_to_many :esquemas, :uniq => true
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
