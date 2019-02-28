require 'active_merchant'

class Payments::CreditCard
  TYPES = {
    'AMEX' => ->(number) { number.size == 15 && number =~ /^(34|37)/ },
    'Discover' => ->(number) { number.size == 16 && number =~ /^6011/ },
    'MasterCard' => ->(number) { number.size == 16 && number =~ /^5[1-5]/ },
    'Visa' => ->(number) { (number.size == 13 || length == 16) && number =~ /^4/ }
  }.freeze

  UNKNOWN_TYPE = 'Unknown'.freeze

  def initialize(params)
    @params = params
  end

  def call
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      number: @params[:card_info][:card_number],
      month: @params[:card_info][:card_expiration_month],
      year: @params[:card_info][:card_expiration_year],
      verification_value: @params[:card_info][:cvv],
      first_name: @params[:card_info][:card_first_name],
      last_name: @params[:card_info][:card_last_name],
      type: get_card_type(@params[:card_info][:card_number])
    )
  end

  def charge(amount)
    # Make the purchase through ActiveMerchant
    charge_amount = (amount.to_f * 100).to_i
    gateway.purchase(charge_amount, @credit_card, options)
  end

  private

  attr_reader :params

  def gateway
    ActiveMerchant::Billing::AuthorizeNetGateway.new(
      login: ENV["AUTHORIZE_LOGIN"],
      password: ENV["AUTHORIZE_PASSWORD"]
    )
  end

  def options
    {
      address: {},
      billing_address: billing_address
    }
  end

  def billing_address
    {
      name: "#{params[:billing_first_name]} #{params[:billing_last_name]}",
      address1: params[:billing_address_line_1],
      city: params[:billing_city],
      state: params[:billing_state],
      country: 'US',
      zip: params[:billing_zip],
      phone: params[:billing_phone]
    }
  end

  def get_card_type(card_number)
    TYPES.each do |type, func|
      return type if func.call(card_number)
    end

    return UNKNOWN_TYPE
  end
end
