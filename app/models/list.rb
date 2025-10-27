class List
  include ActiveModel::Model

  def initialize(name, id)
    @name = name
    @id = id
  end

  attr_reader :name, :id

  # Ordered by the established dates. ruby-list was started in 1995.
  LISTS = [
    List.new('ruby-list', 1),
    List.new('ruby-dev', 2),
    List.new('ruby-core', 3),
    List.new('ruby-talk', 4),
  ]

  class << self
    def find_by_name(name)
      List::LISTS.find { |list| list.name == name }
    end

    def find_by_id(id)
      List::LISTS.find { |list| list.id == id }
    end

    alias find find_by_id
  end

  def to_param
    name
  end

  def persisted?
    true
  end
end
