require "sinatra"
require 'braintree'

class Payments < Sinatra::Base

  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = 'xc4p5dwp2bdcqqqq'
  Braintree::Configuration.public_key = 'y8w3wsj8zgzhxgcn'
  Braintree::Configuration.private_key = 'a2e5245602fa4ab8578f38988b75aeba'


  get '/client_token' do
    content_type :json
    @client_token = Braintree::ClientToken.generate
    JSON.pretty_generate({ :client_token => @client_token})
  end

  post '/simple_transaction' do
    content_type :json
    result = Braintree::Transaction.sale(
      :amount => params["price"],
      :payment_method_nonce => params["payment_method_nonce"],
      :customer => {
          :id => params["customer_id"]
      },
      :options => {
          :store_in_vault_on_success => true
      }
    )
    if result.success?
      puts JSON.pretty_generate(self.to_json(result.transaction))
      JSON.pretty_generate(self.to_json(result.transaction))
    else
      puts JSON.pretty_generate ({ :message => result.message})
      JSON.pretty_generate ({ :message => result.message})
    end

  end

  def to_json(convertObject)
    hash = {}
    convertObject.instance_variables.each do |var|
      hash[var] = convertObject.instance_variable_get var
    end
    hash
  end

  post '/ios_result' do
    params = request.params
    post={
        :amount => "100",
        :payment_method_nonce => params["payment_method_nonce"],
        :options => {
            :submit_for_settlement => true,
            :store_in_vault => true
        },
        :billing => {
            :country_code_alpha2 => "US"
        }
    }
    post[:customer_id] = params["customer_id"] if params["customer_id"]

    result = Braintree::Transaction.sale(post)
    if result.success?
      if result.transaction.payment_instrument_type == "paypal_account"
        method = "PayPal"
        account = result.transaction.paypal_details.payer_email
      else
        method = "Credit Card"
        account = result.transaction.credit_card_details.last_4
      end
      out = {}
      out["customer_id"] = result.transaction.vault_customer.id
      out["info"] = "Transaction ID: #{result.transaction.id}, Payment Method: #{method}, Account: #{account}, Customer ID:#{@customer_id}"

      respond_to do |format|  ## Add this
        format.json { render :json => out}
        ## Other format
      end

    else
      puts "Error: #{result.message}"
      out = "Error: #{result.message}"

      respond_to do |format|  ## Add this
        format.json { render :json => out}
        ## Other format
      end

    end
  end


end

run Payments.run!