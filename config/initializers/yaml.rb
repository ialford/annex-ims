# Added to work around Psych 4 compatibility issue - rjf 3/7/2023
# See https://stackoverflow.com/questions/71191685/visit-psych-nodes-alias-unknown-alias-default-psychbadalias
module YAML
  class << self
    alias_method :load, :unsafe_load if YAML.respond_to? :unsafe_load
  end
end