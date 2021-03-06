require 'pact/shared/active_support_support'
require 'pact/matchers'
require 'pact/symbolize_keys'

module Pact
  class QueryHash

    include ActiveSupportSupport
    include Pact::Matchers
    include SymbolizeKeys

    def initialize query
      @hash = query.nil? ? query : convert_to_hash_of_arrays(query)
    end

    def convert_to_hash_of_arrays query
      symbolize_keys(query).each_with_object({}) {|(k,v), hash| hash[k] = [*v] }
    end

    def as_json opts = {}
      @hash
    end

    def to_json opts = {}
      as_json(opts).to_json(opts)
    end

    def eql? other
      self == other
    end

    def == other
      QueryHash === other && other.query == query
    end

    # other will always be a QueryString, not a QueryHash, as it will have ben created
    # from the actual query string.
    def difference(other)
      diff(query, symbolize_keys(CGI::parse(other.query)), allow_unexpected_keys: false)
    end

    def query
      @hash
    end

    def to_s
      @hash.inspect
    end

    def empty?
      @hash && @hash.empty?
    end

  end
end
