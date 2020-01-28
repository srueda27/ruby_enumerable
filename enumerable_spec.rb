require 'enumerable'

describe 'my_each' do
  it 'block not given' do
    expect([1, 5, 2].my_each.class).to eq(Enumerator)
  end

  it 'returns element without changes' do
    expect([1, 2, 2].my_each { |n| n + 2 }).to eq([1, 2, 2])
  end

  it 'loops an entire array' do
    array = []
    [1, 2, 2].my_each { |n| array[n] = n + 2 }
    expect(array).to eq([nil, 3, 4])
  end

  it 'loops an entire hash' do
    hash = {}
    { a: 1, b: 2, c: 2 }.my_each { |k, v| hash[k] = v + 2 }
    expect(hash).to eq(a: 3, b: 4, c: 4)
  end
end

describe 'my_each_with_index' do
  it 'block not given' do
    expect([1, 5, 2].my_each_with_index.class).to eq(Enumerator)
  end

  it 'returns element without changes' do
    expect([1, 2, 2].my_each_with_index { |n, _idx| n + 2 }).to eq([1, 2, 2])
  end

  it 'loops an entire array' do
    array = []
    [1, 2, 0].my_each_with_index { |n, idx| array[idx] = n + 2 }
    expect(array).to eq([3, 4, 2])
  end

  it 'loops an entire hash' do
    hash = {}
    { a: 1, b: 2, c: 0 }.my_each_with_index { |(k, v), idx| hash[k] = v + idx }
    expect(hash).to eq(a: 1, b: 3, c: 2)
  end
end

describe 'my_select' do
  it 'block not given' do
    expect([1, 5, 2].my_select.class).to eq(Enumerator)
  end

  it 'selects array' do
    expect([1, 2, 4, 5].my_select { |n| n > 3 }).to eq([4, 5])
  end

  it 'selects hash' do
    expect({ a: 1, b: 2, c: 0 }.my_select { |_k, v| v == 2 }).to eq(b: 2)
  end
end

describe 'my_all?' do
  it 'block not given' do
    expect([1, 5, 2].my_all?).to eq(true)
  end

  it 'all with array false' do
    expect([1, 2, 4, 5].my_all? { |n| n > 3 }).to eq(false)
  end

  it 'all with array true' do
    expect([1, 2, 4, 5].my_all? { |n| n >= 1 }).to eq(true)
  end

  it 'all with hash false' do
    expect({ a: 1, b: 2, c: 0 }.my_all? { |_k, v| v == 2 }).to eq(false)
  end

  it 'all with hash true' do
    expect({ a: 1, b: 2, c: 0 }.my_all? { |_k, v| v.is_a? Integer }).to eq(true)
  end
end

describe 'my_any?' do
  it 'block not given' do
    expect([1, 5, 2].my_any?).to eq(true)
  end

  it 'any with array true' do
    expect([1, 2, 4, 5].my_any? { |n| n > 3 }).to eq(true)
  end

  it 'any with array false' do
    expect([1, 2, 4, 5].my_any? { |n| n < 1 }).to eq(false)
  end

  it 'any with hash false' do
    expect({ a: 1, b: 2, c: 0 }.my_any? { |_k, v| v > 20 }).to eq(false)
  end

  it 'any with hash true' do
    expect({ a: 1, b: 2, c: 0 }.my_any? { |_k, v| v.is_a? Integer }).to eq(true)
  end
end

describe 'my_none?' do
  it 'block not given' do
    expect([1, 5, 2].my_none?).to eq(false)
  end

  it 'none with array true' do
    expect([1, 2, 4, 5].my_none? { |n| n > 3 }).to eq(true)
  end

  it 'none with array false' do
    expect([1, 2, 4, 5].my_none? { |n| n >= 1 }).to eq(false)
  end

  it 'none with hash true' do
    expect({ a: 1, b: 2, c: 0 }.my_none? { |_k, v| v == 2 }).to eq(true)
  end

  it 'none with hash false' do
    expect({ a: 1, b: 2, c: 0 }.my_none? { |_k, v| v.is_a? Integer }).to eq(false)
  end
end

describe 'my_count' do
  it 'block not given array' do
    expect([1, 5, 2].my_count).to eq(3)
  end

  it 'block not given hash' do
    expect({ a: 1, b: 2, c: 0, d: 5 }.my_count).to eq(4)
  end

  it 'counts array' do
    expect([1, 5, 2].my_count { |n| n > 4 }).to eq(1)
  end

  it 'counts hash' do
    expect({ a: 1, b: 2, c: 0, d: 5 }.my_count { |_k, v| v < 5 }).to eq(3)
  end
end

describe 'my_map' do
  it 'block not given' do
    expect([1, 5, 2].my_map.class).to eq(Enumerator)
  end

  it 'maps array' do
    expect([1, 2, 4, 5].my_map { |n| n + 2 }).to eq([3, 4, 6, 7])
  end

  it 'maps hash' do
    expect({ a: 1, b: 2, c: 0 }.my_map { |k, v| k.to_s + v.to_s }).to eq(%w[a1 b2 c0])
  end
end
