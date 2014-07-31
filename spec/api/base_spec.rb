require 'spec_helper'

describe Freshdated::Root do
  include Rack::Test::Methods

  def app
    Freshdated::Root
  end

end
