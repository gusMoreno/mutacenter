require 'spec_helper'

describe BuscaController do

  describe "GET 'busca'" do
    it "returns http success" do
      get 'busca'
      response.should be_success
    end
  end

end
