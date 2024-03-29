module SecondAmendmentWholesale
  class Error < StandardError
    
    class BadRequest < SecondAmendmentWholesale::Error; end
    class NotAuthorized < SecondAmendmentWholesale::Error; end
    class NotFound < SecondAmendmentWholesale::Error; end
    class RequestError < SecondAmendmentWholesale::Error; end
    class TimeoutError < SecondAmendmentWholesale::Error; end

  end
end
