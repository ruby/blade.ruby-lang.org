class List
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

  def self.find_by_name(name)
    LISTS.find { |list| list.name == name }
  end

  def self.find_by_id(id)
    LISTS.find { |list| list.id == id }
  end
end
