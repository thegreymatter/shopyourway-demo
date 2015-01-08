class WelcomeController < ApplicationController

  before_filter :set_access
  def set_access
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Request-Method"] = "*"
    # confirmed that both of these show in the headers hash
  end

  def index
    # Javascript request from custom proxy page
    response = HTTParty.get('http://sandboxplatform.shopyourway.com/products/search?q=a&token=0_18385_253402300799_1_07eabcc614049e8a68de05a41c88d0cffb5868c72da9ae0d0e290c7d34396a31&hash=9975bfc470398e9301fe654bcd386e035110469fbaf01e2a31f87e413b73abbb')
    @products = response['products'].shuffle.take(8)

    @user_profile_name = false
    @user_profile_image = false

  end
  def custom
    # How to pass params through the url
    # ?hapyak_username=Dave&hapyak_SYWID=5696025

    # The following is a list of ending user ids which have been tested
    # 5696025, 18, 1

    # Check, parse, and set variables passed through url
    requested_url = request.original_url
    parsed_url = URI.parse(requested_url)

    if parsed_url.query.present?
      parsed_url_hash = CGI.parse(parsed_url.query)
      syw_user_id = parsed_url_hash['hapyak_SYWID'][0]
    else
      parsed_url_hash = false
      syw_user_id = false
    end

    # Reading response from app proxy page
    response = HTTParty.get('http://sandboxplatform.shopyourway.com/products/search?q=movie&orderBy=top_sellers&token=0_18385_253402300799_1_07eabcc614049e8a68de05a41c88d0cffb5868c72da9ae0d0e290c7d34396a31&hash=9975bfc470398e9301fe654bcd386e035110469fbaf01e2a31f87e413b73abbb')
    @products = response['products']

    # Shopyourway User Profile Request
    user_profile_base_url = "http://sandboxplatform.shopyourway.com/users/get?token=0_18385_253402300799_1_07eabcc614049e8a68de05a41c88d0cffb5868c72da9ae0d0e290c7d34396a31&hash=9975bfc470398e9301fe654bcd386e035110469fbaf01e2a31f87e413b73abbb&ids="
    if syw_user_id
      user_profile = HTTParty.get(user_profile_base_url+syw_user_id);
    end
    if !user_profile.nil? && !user_profile.empty?
      @user_profile_name = user_profile[0]['name'].split(' ').first.capitalize
      @user_profile_image = user_profile[0]['imageUrl']
    else
      @user_profile_name = false
      @user_profile_image = false
    end
  end
  def proxy
    def convertToString obj

      if obj.is_a?(String)

        obj.to_s

      elsif obj.is_a?(Array)

        obj.map {|value| convertToString value }

      elsif obj.is_a?(Hash)

        obj.merge( obj ) {|key, value| convertToString value }

      else

        obj = obj.to_s

      end
    end

    response = HTTParty.get('http://sandboxplatform.shopyourway.com/products/search?q=toys&orderBy=top_sellers&token=0_18385_253402300799_1_07eabcc614049e8a68de05a41c88d0cffb5868c72da9ae0d0e290c7d34396a31&hash=9975bfc470398e9301fe654bcd386e035110469fbaf01e2a31f87e413b73abbb')
    @products = response['products']

    @products = convertToString @products
    render json: @products

  end
end
