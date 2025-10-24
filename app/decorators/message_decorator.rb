# frozen_string_literal: true

module MessageDecorator
  def from
    super&.gsub(/@[a-zA-Z.\-]+/, '@...')
  end

  def first_line
    body.lines.first&.strip
  end
end
