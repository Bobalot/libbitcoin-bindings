namespace std {
struct error_code
  {
    void clear();

    int value() const;
      
 /*   const error_category& category() const;*/

    std::error_condition default_error_condition() const;

    string message() const;

    explicit operator bool() const;
};

}
