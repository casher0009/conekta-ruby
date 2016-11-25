module Conekta
  class List < ConektaObject
    attr_reader :elements_type, :params, :starting_after, :ending_before, :has_more, :total

    def initialize(elements_type, params)
      super()
      @elements_type = elements_type
      @params = (params || {})
    end

    def next(limit=nil)
      if !@ending_before.nil?
        @params["starting_after"] = self.first.id
      else
        @params["starting_after"] = self.last.id
      end
      @params["ending_before"] = nil
      move_cursor(limit)
    end

    def previous(limit=nil)
      if !@ending_before.nil?
        @params["ending_before"] = self.last.id
      else
        @params["ending_before"] = self.first.id
      end
      @params["starting_after"] = nil
      move_cursor(limit)
    end
    
    def load_from(response)
      @starting_after = response["starting_after"]
      @ending_before = response["ending_before"]
      @has_more = response["has_more"]
      @total = response["total"]
      super(response["data"])
    end

    private
    def move_cursor(limit)
      @values = Hash.new
      @params["limit"] = limit if !limit.nil? && !limit.to_s.empty?
      _url = Util.types[@elements_type.downcase]._url
      response = Requestor.new.request(:get, _url, @params)
      self.load_from(response)
    end
  end
end