require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe :conekta_tests do
  Conekta.api_key = '1tv5yJp3xnVZ7eK67m4h'
  describe :charge_tests do
    before :each do
      @valid_payment_method = {amount: 2000, currency: 'mxn', description: 'Some desc'}
      @invalid_payment_method = {amount: 10, currency: 'mxn', description: 'Some desc'}
      @valid_visa_card = {card: 'tok_test_visa_4242'}
    end
    p "charge tests"
    it "succesful get charge" do
      pm = @valid_payment_method
      card = @valid_visa_card
      cpm = Conekta::Charge.create(pm.merge(card))
      cpm.status.should eq("paid")
      pm = Conekta::Charge.get(cpm.id)
      pm.class.class_name.should eq("Charge")
    end
    it "test succesful where" do
      charges = Conekta::Charge.where
      charges.class.class_name.should eq("ConektaObject")
      charges[0].class.class_name.should eq("Charge")
    end
    it "tests succesful bank pm create" do
      pm = @valid_payment_method
      bank = {bank: {'type' => 'banorte'}}
      bpm = Conekta::Charge.create(pm.merge(bank))
      bpm.status.should eq("pending_payment")
    end
    it "tests succesful card pm create" do
      pm = @valid_payment_method
      card = @valid_visa_card
      cpm = Conekta::Charge.create(pm.merge(card))
      cpm.status.should eq("paid")
    end
    it "tests succesful oxxo pm create" do
      pm = @valid_payment_method
      oxxo = {cash: {'type' => 'oxxo'}}
      bpm = Conekta::Charge.create(pm.merge(oxxo))
      bpm.status.should eq("pending_payment")
    end
    it "test unsuccesful pm create" do
      pm = @invalid_payment_method
      card = @valid_visa_card
      begin
        cpm = Conekta::Charge.create(pm.merge(card))
      rescue Exception => e
        e.message.should eq("The minimum purchase is 3 MXN pesos for card payments")
      end
    end
    it "test susccesful refund" do
      pm = @valid_payment_method
      card = @valid_visa_card
      cpm = Conekta::Charge.create(pm.merge(card))
      cpm.status.should eq("paid")
      cpm.refund
      cpm.status.should eq("refunded")
    end
    it "test unsusccesful refund" do
      pm = @valid_payment_method
      card = @valid_visa_card
      cpm = Conekta::Charge.create(pm.merge(card))
      cpm.status.should eq("paid")
      begin
        cpm.refund(3000)
      rescue Exception => e
        e.message.should eq("The order does not exist or the amount to refund is invalid")
      end
    end
    it "tests succesful card pm create" do
      pm = @valid_payment_method
      card = @valid_visa_card
      capture = {capture: false}
      cpm = Conekta::Charge.create(pm.merge(card).merge(capture))
      cpm.status.should eq("pre_authorized")
      cpm.capture
      cpm.status.should eq("paid")
    end
  end
  describe :customer_tests do
#    it "gets a customer" do
#      p "gets a customer"
#      customer = Conekta::Customer.get("cus_eVXwZTpkefmjvmVj8")
#      p customer
#      p customer.cards[0]
#    end
#    it "creates a customer" do
#      p "creates a customer"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"],
#        :plan => "gold-plan"
#      })
#      p customer
#    end
#    it "deletes a customer" do
#      p "deletes a customer"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"],
#        :plan => "gold-plan"
#      })
#      p customer
#      customer.delete
#      p customer
#      p customer.deleted
#    end
#    it "updates a customer" do
#      p "updates a customer"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"],
#        :plan => "gold-plan"
#      })
#      p customer
#      customer.update({
#        :name => "Logan",
#        :email => "logan@x-men.org",
#      })
#      p customer
#    end
#    it "creates a customer card" do
#      p "creates a customer card"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"],
#        :plan => "gold-plan"
#      })
#      p customer
#      card = customer.create_card(:token => 'tok_test_visa_1881')
#      p "new customer"
#      p customer
#      card = customer.create_card(:token => 'tok_test_mastercard_4444')
#      p "new customer"
#      p customer
#    end
#    it "deletes and creates card" do
#      p "deletes and creates card"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"],
#        :plan => "gold-plan"
#      })
#      card = customer.create_card(:token => 'tok_test_visa_1881')
#      card = customer.create_card(:token => 'tok_test_mastercard_4444')
#      p customer.cards
#      p "#0"
#      p customer.cards[0]
#      p "#1"
#      p customer.cards[1]
#      p "#2"
#      p customer.cards[2]
#      p "delete"
#      p customer.cards[0].delete
#      p "#0"
#      p customer.cards[0]
#      p "delete"
#      p customer.cards[0].delete
#      p "#0"
#      p customer.cards[0]
#      p "#0 cus"
#      p customer.cards[0].customer
#      p "delete"
#      p customer.cards[0].delete
#      p "#0"
#      p customer.cards[0]
#      p customer.cards.class
#    end
#    it "creates a subscription" do
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"]
#      })
#      p customer
#      customer.create_subscription({
#          :plan => "gold-plan"
#        })
#      p customer
#    end
#    it "updates subscription" do
#      p "updates subscription"
#      customer = Conekta::Customer.create({
#        :name => "James Howlett",
#        :email => "james.howlett@forces.gov",
#        :phone => "55-5555-5555",
#        :cards => ["tok_test_visa_4242"]
#      })
#      p customer
#      customer.create_subscription({
#          :plan => "gold-plan"
#        })
#      p customer
#      customer.subscription.update({:plan => "gold-plan3"})
#      p customer
#    end
  end
  describe :plan_tests do
#    it "get plan" do
#      p "get plan"
#      plans = Conekta::Plan.where
#      p plans
#      p = plans.first
#      plan = Conekta::Plan.get(p.id)
#      p plan
#    end
#    it "creates plan" do
#      p "creates plan"
#      plans = Conekta::Plan.where
#      plan = Conekta::Plan.create({
#        :id => "gold-plan" + plans.count.to_s,
#        :name => "Gold Plan",
#        :amount => 10000,
#        :currency => "MXN",
#        :interval => "month",
#        :frequency => 1,
#        :trial_period_days => 15,
#        :expiry_count => 12})
#      p plan
#    end
#    it "update plan" do
#      p "update plan"
#      plans = Conekta::Plan.where
#      plan = plans.first
#      plan.update({:name => 'Silver Plan'})
#      p plan
#    end
#    it "delete plan" do
#      p "delete plan"      
#      plans = Conekta::Plan.where
#      p plans.count
#      plan = plans.first
#      p plan.delete
#      p plans.count
#      p plans
#    end
  end

end
