require './spec/helper'
require 'minitest/hooks/default'
require 'open3'

RUBY = ENV['RUBY'] || 'ruby'

describe 'Minitest::Hooks error handling' do
  def self.run_test(desc, runs, errors)
    it "should handle errors in #{desc}" do
      ENV['MINITEST_HOOKS_ERRORS'] = desc
      Open3.popen3(RUBY, "spec/errors/example.rb") do  |_, o, e, w|
        o.read.must_match /#{runs} runs, 0 assertions, 0 failures, #{errors} errors, 0 skips/
        e.read.must_equal ''
        w.value.exitstatus.wont_equal 0 if w
      end
    end
  end

  run_test "before-all", 1, 1
  run_test "before", 3, 3
  run_test "after", 3, 3
  run_test "after-all", 4, 1
  run_test "around-before", 1, 1
  run_test "around-after", 1, 1
  run_test "around-all-before", 1, 1
  run_test "around-all-after", 4, 1
end
