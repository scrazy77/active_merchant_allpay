#encoding: utf-8

require 'cgi'
require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Allpay
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          ### 常見介面

          # 廠商編號
          mapping :merchant_id, 'MerchantID'
          mapping :account, 'MerchantID' # AM common
          # 廠商交易編號
          mapping :merchant_trade_no, 'MerchantTradeNo'
          mapping :order, 'MerchantTradeNo' # AM common
          # 交易金額
          mapping :total_amount, 'TotalAmount'
          mapping :amount, 'TotalAmount' # AM common
          # 付款完成通知回傳網址
          mapping :notify_url, 'ReturnURL' # AM common
          # Client 端返回廠商網址
          # mapping :client_back_url, 'ClientBackURL'
          mapping :return_url, 'ClientBackURL' # AM common
          # 付款完成 redirect 的網址
          mapping :redirect_url, 'OrderResultURL'
          # 交易描述
          mapping :description, 'TradeDesc'
          # ATM, CVS 序號回傳網址 (Server Side)
          mapping :payment_info_url, 'PaymentInfoURL'
          # ATM, CVS 序號頁面回傳網址 (Client Side)
          mapping :payment_redirect_url, 'ClientRedirectURL'
          # ATM Expiration Setting by Days
          mapping :expire_date, "ExpireDate"
          # CVS Expiration Setting by Minutes
          mapping :stop_expire_date, "StoreExpireDate"

          ### Allpay 專屬介面

          # 交易類型
          mapping :payment_type, 'PaymentType'

          # 選擇預設付款方式
          #   Credit:信用卡
          #   WebATM:網路 ATM
          #   ATM:自動櫃員機
          #   CVS:超商代碼
          #   BARCODE:超商條碼
          #   Alipay:支付寶
          #   Tenpay:財付通
          #   TopUpUsed:儲值消費
          #   ALL:不指定付款方式, 由歐付寶顯示付款方式 選擇頁面
          mapping :choose_payment, 'ChoosePayment'

          mapping :choose_sub_payment, 'ChooseSubPayment'

          # 商品名稱
          # 多筆請以井號分隔 (#)
          mapping :item_name, 'ItemName'

          # 信用卡
          mapping :language, "Language"

          # 支付寶
          mapping :alipay_item_name, "AlipayItemName"
          mapping :alipay_item_counts, "AlipayItemCounts"
          mapping :alipay_item_price, "AlipayItemPrice"
          mapping :email, "Email"
          mapping :phone_no, "PhoneNo"
          mapping :user_name, "UserName"

          # 銀聯卡
          mapping :union_pay, "UnionPay"

          def initialize(order, account, options = {})
            super
            add_field 'MerchantID', ActiveMerchant::Billing::Integrations::Allpay.merchant_id
            add_field 'PaymentType', ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_TYPE
          end

          def merchant_trade_date(date)
            add_field 'MerchantTradeDate', date.strftime('%Y/%m/%d %H:%M:%S')
          end

          def encrypted_data

            url_encrypted_data = ActiveMerchant::Billing::Integrations::Allpay.fetch_url_encode_data(@fields)

            binding.pry if ActiveMerchant::Billing::Integrations::Allpay.debug

            add_field 'CheckMacValue', url_encrypted_data
          end

        end
      end
    end
  end
end
