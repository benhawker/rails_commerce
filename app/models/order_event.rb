# == Schema Information
#
# Table name: order_events
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  event_type  :string(255)
#  action_type :string(255)
#  from_state  :string(255)
#  to_state    :string(255)
#  note        :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#
# Indexes
#
#  index_order_events_on_order_id  (order_id)
#

class OrderEvent < ActiveRecord::Base
  belongs_to :order
  belongs_to :user

  def self.log_transition(order_id, type, from_state, to_state, user)
    OrderEvent.create(order_id: order_id,
                      event_type: type.to_s,
                      from_state: from_state,
                      to_state: to_state,
                      user: user)
  end

  def state_changed?
    from_state && to_state
  end
end
