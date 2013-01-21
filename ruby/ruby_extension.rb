require 'matrix'

class Hash
  # returns a new hash including the keys that passed
  def only *keys
    new_hash = {}
    keys.each do |el|
      new_hash[el.to_sym] = self[el] if self.has_key?(el)
    end
    new_hash
  end
end

class Array
  # convert an array to vector
  def to_v
    Vector.elements(self)
  end
end

# make single elements assignable
class Vector
  def []=(i, x)
    @elements[i] = x
  end

  def to_v
    Vector.elements(self)
  end
end

class Class
  def to_sym
    self.class.to_s.downcase.to_sym
  end
end