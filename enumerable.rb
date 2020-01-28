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

  def my_all?
    # see if all or no values match condition
    return true unless block_given?

    my_each do |n|
      # return true unless any of the values does not meet the statement
      if is_a? Hash
        return false unless yield n.to_a[0], n.to_a[1]
      elsif !(yield n)
        return false
      end
    end

    true
  end

  def my_any?
    # see if any of the values match condition
    return true unless block_given?

    my_each do |n|
      # return true if any of the values meet the statement
      if is_a? Hash
        return true if yield n.to_a[0], n.to_a[1]
      elsif yield n
        return true
      end
    end

    false
  end

  def my_none?
    # the reverse of my_all?
    return false unless block_given?

    my_each do |n|
      if is_a? Hash
        return true unless yield n.to_a[0], n.to_a[1]
      elsif !(yield n)
        return true
      end
    end

    false
  end

  def my_count
    return length unless block_given?

    count = 0

    my_each do |n|
      if is_a? Hash
        count += 1 if yield n.to_a[0], n.to_a[1]
      elsif yield n
        count += 1
      end
    end

    count
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    return_element = []

    my_each_with_index do |n, idx|
      return_element[idx] = yield n
    end

    return_element
  end
end
