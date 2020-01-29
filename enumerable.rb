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
        # |(array), idx|, since its receiving an array (inside the parenthesis) I had to return an array
        yield [to_a[idx][0], to_a[idx][1]], idx
      else
        yield self[idx], idx
      end
    end

    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    # the select method works passing a true/false statement (a comparison) via the block (yield)
    # and return back an Array/Hash depending what it got

    return_element = self.class.new

    my_each do |n|
      # if it is a Hash then I need to add the key and value if the pair is "selected" (the statement/yield is true)
      if is_a? Hash
        return_element[n.to_a[0]] = n.to_a[1] if yield n.to_a[0], n.to_a[1]
      elsif yield n
        # If not a Hash and the statement is true push the element to the array
        # Convert if nested into and elsif.
        # It is made with an elsif because if not a Hash then an Array, and the only else statement is
        # if yield is true or false.
        return_element.push(n)
      end
    end

    return_element
  end

  def my_all?(args = nil)
    if args.nil?
      return my_select { |element| element == false || element.nil? }.empty? unless block_given?

      my_each do |n|
        # return true unless any of the values does not meet the statement
        return false unless yield n
      end
    elsif args.is_a? Regexp
      return my_select { |element| !element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      return my_select { |element| element.class != args }.empty?
    else
      return my_select { |element| element != args }.empty?
    end

    true
  end

  def my_any?(args = nil)
    if args.nil?
      return !my_select { |element| element != false && !element.nil? }.empty? unless block_given?

      my_each do |n|
        return true if yield n
      end
    elsif args.is_a? Regexp
      return !my_select { |element| element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      return !my_select { |element| element.class == args }.empty?
    else
      return !my_select { |element| element == args }.empty?
    end

    false
  end

  def my_none?(args = nil)
    if args.nil?
      return !my_select { |element| element == false || element.nil? }.empty? unless block_given?

      my_each do |n|
        # return true unless any of the values does not meet the statement
        return true unless yield n
      end
    elsif args.is_a? Regexp
      return !my_select { |element| !element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      return !my_select { |element| element.class != args }.empty?
    else
      return !my_select { |element| element != args }.empty?
    end

    false
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
    return raise 'no block given' unless block_given?

    array = proper_array_for_inject(self)

    if initial.nil?
      initial = array[0]
      array.shift
    elsif (initial.is_a? Hash) || (initial.is_a? Array)
      initial = initial[0].class.new
    end

    unless sim.nil?
      array.my_each do |n|
        initial = initial.send sim, n
      end
    end

    array.my_each do |n|
      initial = yield initial, n
    end

    initial
  end

  def proper_array_for_inject(parms)
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
