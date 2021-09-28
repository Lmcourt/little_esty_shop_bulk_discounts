class BulkDiscountService
  class << self
    def holidays
      response = conn.get("/api/v2/NextPublicHolidays/US")
      parse_data(response)
    end

    def next_three_holidays
      holidays.first(3)
    end

    private
    def conn
      Faraday.new("https://date.nager.at")
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
