require 'flipper'
require 'flipper/adapters/active_record'

module Flipper
  module Rails
    def self.flipper
      @flipper ||= Flipper.new(Flipper::Adapters::ActiveRecord.new)
    end
  end
end
