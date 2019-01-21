require 'rails_helper'

RSpec.describe Chatbase, type: :lib do
  let(:user_id) { '12345678' }
  let(:group_id) { '12345678' }
  let(:potential_rumor) { '' }
  let(:bot_reply) { '' }

  describe '#intent_with_handling' do
    subject { Chatbase.new(user_id, potential_rumor, group_id) }

    xit 'should post to chatbase successfully' do
      
    end
  end

  describe '#send_bot_message' do
    subject { Chatbase.new(user_id, bot_reply, group_id) }

    xit 'should post to chatbase successfully' do
      
    end
  end
end
