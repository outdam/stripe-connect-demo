require "active_model"

class Charge
  include ActiveModel::Model

  attr_accessor :token, :amount, :currency, :description

  validates :amount, :token, presence: true

  def save
    return false unless valid?

    execute_charge
  end

  private

  def execute_charge
    Stripe::Charge.create(
      amount: amount_in_cents,
      currency: "USD",
      source: token,
      description: "New charge #{Time.zone.now}"
    )
    true
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
    puts e.message
    false
  end

  def amount_in_cents
    (amount.to_f * 100).to_i
  end
end