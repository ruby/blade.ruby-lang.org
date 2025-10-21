# frozen_string_literal: true

module MessageDecorator
  def from
    super&.gsub(/@[a-zA-Z.\-]+/, '@...')
  end
end
