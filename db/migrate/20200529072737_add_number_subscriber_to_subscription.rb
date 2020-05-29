class AddNumberSubscriberToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :number_of_user, :integer
  end
end
