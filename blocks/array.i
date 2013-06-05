namespace std { 

  template<typename _Tp, std::size_t _Nm> 
    struct array 
    { 
      typedef _Tp                      value_type; 
      typedef value_type&                          reference; 
      typedef const value_type&                    const_reference; 
      typedef value_type*                    iterator; 
      typedef const value_type*              const_iterator; 
      typedef std::size_t                             size_type; 
      typedef std::ptrdiff_t                          difference_type; 
      typedef std::reverse_iterator<iterator>         reverse_iterator; 
      typedef std::reverse_iterator<const_iterator>   
const_reverse_iterator; 

      size_type size() const; 

      reference at(size_type __n); 
    }; 

} 


%extend std::array { 
    inline size_t __len__() const { return $self->size(); } 

    inline const value_type& _get(size_t i) const 
throw(std::out_of_range) { 
        return $self->at(i); 
    } 

    inline void _set(size_t i, const value_type& v) 
throw(std::out_of_range) { 
        $self->at(i) = v; 
    } 

    %pythoncode { 
        def __getitem__(self, key): 
            if isinstance(key, slice): 
                return tuple(self._get(i) for i in range(*key.indices(len(self)))) 

            if key < 0: 
                key += len(self) 
            return self._get(key) 
        
        def __setitem__(self, key, v): 
            if isinstance(key, slice): 
                for i in range(*key.indices(len(self))): 
                    self._set(i, v[i]) 
            else: 
                if key < 0: 
                    key += len(self) 
                self._set(key, v) 

        def __repr__(self): 
            return "%s(%s)" % (self.__class__.__name__, ", ".join(str(v) for v in self[:])) 
    } 
} 

