require_relative './play.rb'

class TestCase
  @@passes = 0
  @@failures = 0
  @@failure_messages = []

  AssertionError = Class.new(StandardError)

  def assert(expected, actual)
    if expected == actual
      @@passes += 1
      print '.'
    else
      @@failures += 1
      print 'F'
      fail AssertionError, "#{expected} does not equal #{actual}"
    end

  rescue StandardError => e
binding.pry
    @@failure_messages << e.message
  end

  def self.implementations
    @implementations ||= []
  end

  def self.inherited(base)
    implementations << base
  end

  def self.run
    implementations.each do |klass|
      klass.instance_methods(false).each { |m| klass.new.public_send(m) }
    end
    print_error_messages
    finish
  end

  def self.print_error_messages
    @@failure_messages.each { |message| puts "\n\n#{message}" }
  end

  def self.finish
    puts "\n\n(#{@@passes} passed, #{@@failures} failed)\n"
  end
end

class DeckTest < TestCase
  def test_size
    deck = Deck.new
    assert(deck.size, 52)
  end

  def test_draw
    deck = Deck.new
    assert(deck.draw.class, "Card")
  end
end

TestCase.run
