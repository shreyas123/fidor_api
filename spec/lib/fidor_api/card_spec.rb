require "spec_helper"

describe FidorApi::Card do

  let(:client) { FidorApi::Client.new(token: token) }
  let(:token)  { FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937") }

  def expect_correct_card(card)
    expect(card).to be_instance_of FidorApi::Card
    expect(card.id).to                         eq 42
    expect(card.account_id).to                 eq "875"
    expect(card.inscription).to                eq "Philipp Müller"
    expect(card.type).to                       eq "fidor_debit_master_card"
    expect(card.design).to                     eq "debit-card"
    expect(card.currency).to                   eq "EUR"
    expect(card.physical).to                   be true
    expect(card.balance).to                    eq 0
    expect(card.atm_limit).to                  eq BigDecimal.new("1000.0")
    expect(card.transaction_single_limit).to   eq BigDecimal.new("2000.0")
    expect(card.transaction_volume_limit).to   eq BigDecimal.new("3000.0")
    expect(card.email_notification).to         be true
    expect(card.sms_notification).to           eq false
    expect(card.payed).to                      be true
    expect(card.state).to                      eq "card_registration_completed"
    expect(card.lock_reason).to                be_nil
    expect(card.disabled).to                   be true
    expect(card.created_at).to                 eq DateTime.new(2015, 11, 3, 11,  7, 25)
    expect(card.updated_at).to                 eq DateTime.new(2015, 11, 9, 10, 55,  6)
  end

  describe ".all" do
    it "returns all card records" do
      VCR.use_cassette("card/all", record: :once) do
        cards = client.cards
        expect(cards).to be_instance_of FidorApi::Collection
        expect_correct_card(cards.first)
      end
    end
  end

  describe ".find" do
    it "returns one card record" do
      VCR.use_cassette("card/find", record: :once) do
        card = client.card 42
        expect_correct_card(card)
      end
    end
  end

end