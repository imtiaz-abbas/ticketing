require "test_helper"

class KnowmanShowTest < ActiveSupport::TestCase
    test "should create show" do
        show = KnowmanShow.new
        Sidekiq::Worker.drain_all
        show.save
        assert_equal 1, KnowmanShow.count
        assert_equal DateTime.now.change({ hour: 16, minute: 00 }), show.date
        assert_not_nil show
    end
end
