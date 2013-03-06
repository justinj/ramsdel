module Ramsdel
  class Parser
    def tokenize definition
      definition.gsub(/\s/, "").split("+")
    end
  end
end
