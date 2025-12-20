class List
  include ActiveModel::Model

  def initialize(id, name, label)
    @id, @name, @label = id, name, label
    nil
  end

  attr_reader :id, :name, :label

  # Ordered by the established dates. ruby-list was started in 1995.
  LISTS = [
    List.new(1, 'ruby-list', 'ruby-list (For Ruby users, JA)'),
    List.new(2, 'ruby-dev', 'ruby-dev (For Ruby developers, JA)'),
    List.new(3, 'ruby-core', 'ruby-core (For Ruby developers, EN)'),
    List.new(4, 'ruby-talk', 'ruby-talk (For Ruby users, EN)')
  ]

  class << self
    def find_by_id(id)
      List.all.detect { |list| list.id == id }
    end

    alias find find_by_id

    def find_by_name(name)
      List.all.detect { |list| list.name == name }
    end

    def all
      List::LISTS
    end
  end

  def to_param
    name
  end

  def persisted?
    true
  end
end
