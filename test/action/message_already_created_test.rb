require 'test_helper'

require 'vagrant/machine_state'
require 'vagrant-vrealize/action/message_already_created'

class MessageAlreadyCreatedTest < VrealizeActionTest
  class FakeLogger
    attr_reader :message
    def info(message)
      @message = message
    end
  end

  def setup
    @old_backend = I18n.backend
    I18n.backend = I18n::Backend::Simple.new
  end

  def test_sends_message
    locale_def = {
      "vagrant_vrealize" => {"already_status" => "My status: %{status}"}
    }

    I18n.backend.store_translations(:en, locale_def)
    sink = FakeLogger.new
    action = MessageAlreadyCreated.new(->(_){}, {})

    action.call(ui: sink)

    assert_equal(sink.message, "My status: created")
  end

  def teardown
    I18n.backend = @old_backend
  end
end
