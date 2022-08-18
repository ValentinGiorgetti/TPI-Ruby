module ApiHelper
    def check_id(id)
      id && (id.to_i.to_s == id) && (id.to_i >= 0)
    end

    def check_date_string(date)
      raise ArgumentError if date.split("-").map{|number| number.scan(/\D/).empty?}.include?(false)
      Date.strptime(date, '%d-%m-%Y')
    end

    def add_pagination_info(collection)
        current = collection.current_page
        total = collection.total_pages
      
        {
          pagination_info: {
            current_page:            current,
            total_elements_in_page:  collection.size,
            previous_page:           (current > 1 ? (current - 1) : nil),
            next_page:               (current == total ? nil : (current + 1)),
            total_found_elements:    collection.total_count,
            per_page:                collection.limit_value,
            total_pages:             total,
          },
          data: collection
        }
    end
end