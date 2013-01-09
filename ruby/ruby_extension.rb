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