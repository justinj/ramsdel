module Ramsdel
  class Parser
    def tokenize definition
      definition.split(/\s*\+\s*/)
    end
  end
end
