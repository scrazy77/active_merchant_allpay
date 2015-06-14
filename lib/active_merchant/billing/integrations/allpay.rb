require File.dirname(__FILE__) + '/allpay/helper.rb'
require File.dirname(__FILE__) + '/allpay/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Allpay
        autoload :Helper, 'active_merchant/billing/integrations/allpay/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/allpay/notification.rb'

        PAYMENT_CREDIT_CARD = 'Credit'
        PAYMENT_ATM         = 'ATM'
        PAYMENT_CVS         = 'CVS'
        PAYMENT_ALIPAY      = 'Alipay'

        SUBPAYMENT_ATM_TAISHIN      = 'TAISHIN'
        SUBPAYMENT_ATM_ESUN         = 'ESUN'
        SUBPAYMENT_ATM_HUANAN       = 'HUANAN'
        SUBPAYMENT_ATM_BOT          = 'BOT'
        SUBPAYMENT_ATM_FUBON        = 'FUBON'
        SUBPAYMENT_ATM_CHINATRUST   = 'CHINATRUST'
        SUBPAYMENT_ATM_FIRST        = 'FIRST'

        SUBPAYMENT_CVS_CVS    = 'CVS'
        SUBPAYMENT_CVS_OK     = 'OK'
        SUBPAYMENT_CVS_FAMILY = 'FAMILY'
        SUBPAYMENT_CVS_HILIFE = 'HILIFE'
        SUBPAYMENT_CVS_IBON   = 'IBON'

        PAYMENT_TYPE        = 'aio'

        mattr_accessor :refund_url
        mattr_accessor :service_url
        mattr_accessor :merchant_id
        mattr_accessor :hash_key
        mattr_accessor :hash_iv
        mattr_accessor :debug

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              'https://payment.allpay.com.tw/Cashier/AioCheckOut'
            when :development
              'http://payment-stage.allpay.com.tw/Cashier/AioCheckOut'
            when :test
              'http://payment-stage.allpay.com.tw/Cashier/AioCheckOut'
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.refund_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              'https://payment.allpay.com.tw/Cashier/AioChargeback'
            when :development
              'http://payment-stage.allpay.com.tw/Cashier/AioChargeback'
            when :test
              'http://payment-stage.allpay.com.tw/Cashier/AioChargeback'
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post)
          Notification.new(post)
        end

        def self.setup
          yield(self)
        end

        def self.fetch_url_encode_data(fields)
          raw_data = fields.sort.map{|field, value|
            # utf8, authenticity_token, commit are generated from form helper, needed to skip
            "#{field}=#{value}" if field!='utf8' && field!='authenticity_token' && field!='commit'
          }.join('&')

          hash_raw_data = "HashKey=#{ActiveMerchant::Billing::Integrations::Allpay.hash_key}&#{raw_data}&HashIV=#{ActiveMerchant::Billing::Integrations::Allpay.hash_iv}"
          url_encode_data = self.url_encode(hash_raw_data)
          url_encode_data.downcase!
          url_encode_data
        end

        # Allpay .NET url encoding
        # Code based from CGI.escape()
        # Some special characters (e.g. "()*!") are not escaped on Allpay server when they generate their check sum value, causing CheckMacValue Error.
        #
        # TODO: The following characters still cause CheckMacValue error:
        #       '<', "\n", "\r", '&'
        def self.url_encode(text)
          text = text.dup
          text.gsub!(/([^ a-zA-Z0-9\(\)\!\*_.-]+)/) do
            '%' + $1.unpack('H2' * $1.bytesize).join('%')
          end
          text.tr!(' ', '+')
          text
        end

      end
    end
  end
end
