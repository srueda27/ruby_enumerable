module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    length.times do |idx|
      if is_a? Hash
        yield [to_a[idx][0], to_a[idx][1]]
      else
        yield self[idx]
      end
    end

    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    length.times do |idx|
      if is_a? Hash
        yield [to_a[idx][0], to_a[idx][1]], idx
      else
        yield self[idx], idx
      end
    end

    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    return_element = self.class.new

    my_each do |n|
      if is_a? Hash
        return_element[n.to_a[0]] = n.to_a[1] if yield n.to_a[0], n.to_a[1]
      elsif yield n
        return_element.push(n)
      end
    end

    return_element
  end

  def my_all?(args = nil)
    if args.nil?
      return my_select { |element| element == false || element.nil? }.empty? unless block_given?

      my_each do |n|
        return false unless yield n
      end
    end

    return validate_all(args) unless args.nil?

    true
  end

  def validate_all(args)
    if args.is_a? Regexp
      my_select { |element| !element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      my_select { |element| element.class != args }.empty?
    else
      my_select { |element| element != args }.empty?
    end
  end

  def my_any?(args = nil)
    if args.nil?
      return !my_select { |element| element != false && !element.nil? }.empty? unless block_given?

      my_each do |n|
        return true if yield n
      end
    end

    return validate_any(args) unless args.nil?

    false
  end

  def validate_any(args)
    if args.is_a? Regexp
      !my_select { |element| element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      !my_select { |element| element.class == args }.empty?
    else
      !my_select { |element| element == args }.empty?
    end
  end

  def my_none?(args = nil)
    if args.nil?
      return my_select { |element| element == true }.empty? unless block_given?

      my_each do |n|
        return true unless yield n
      end
    end

    return validate_none(args) unless args.nil?

    false
  end

  def validate_none(args)
    if args.is_a? Regexp
      my_select { |element| element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      my_select { |element| element.class == args }.empty?
    else
      my_select { |element| element == args }.empty?
    end
  end

  def my_count(args = nil)
    if args.nil?
      return length unless block_given?

      count = 0

      my_each do |n|
        count += 1 if yield n
      end

      count
    else
      my_select { |n| n == args }.size
    end
  end

  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    return_element = []

    if !proc.nil?
      my_each_with_index do |n, idx|
        return_element[idx] = proc.call(n)
      end
    else
      my_each_with_index do |n, idx|
        return_element[idx] = yield n
      end
    end

    return_element
  end

  def my_inject(initial = nil, sim = nil)
    array = return_array(self)

    if initial.nil?
      initial = array[0]
      array = array[1..-1]
    elsif (initial.is_a? Hash) || (initial.is_a? Array)
      initial = initial[0].class.new
    end

    no_block_simbol_value = validate_no_block_symbol(block_given?, initial, array)

    return no_block_simbol_value unless no_block_simbol_value.nil?

    unless sim.nil?
      array.my_each { |n| initial = initial.send sim, n }
      return initial
    end

    array.my_each do |n|
      initial = yield initial, n
    end

    initial
  end

  def validate_no_block_symbol(given_block, initial, array)
    operate_initial_symbol(initial, array) if !given_block && (initial.is_a? Symbol)
  end

  def operate_initial_symbol(initial, array)
    symbol = initial
    initial = array[0]
    array = array[1..-1]
    array.my_each { |n| initial = initial.send symbol, n }
    initial
  end

  def return_array(parms)
    if parms.is_a? Range
      parms.to_a
    else
      parms
    end
  end
end

def multiply_els(array)
  array.my_inject { |multiply, n| multiply * n }
end
