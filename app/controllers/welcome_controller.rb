class WelcomeController < ApplicationController

  def index
    response = HTTParty.get('http://sandboxplatform.shopyourway.com/products/search?q=toy&token=0_18385_253402300799_1_07eabcc614049e8a68de05a41c88d0cffb5868c72da9ae0d0e290c7d34396a31&hash=9975bfc470398e9301fe654bcd386e035110469fbaf01e2a31f87e413b73abbb')
    @products = response['products']
    puts response.body, response.code, response.message, response.headers.inspect
  end

end
