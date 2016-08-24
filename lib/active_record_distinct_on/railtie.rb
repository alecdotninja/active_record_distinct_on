require 'active_record_distinct_on'

module ActiveRecordDistinctOn
  class Railtie < ::Rails::Railtie
    initializer 'active_record_distinct_on.monkey_patch_active_record' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecordDistinctOn.install
      end
    end
  end
end