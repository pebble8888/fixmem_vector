/*
 *  fixmem_vector.h
 *
 *  Created by pebble8888 on 2016/09/03.
 *  Copyright © 2016 pebble8888. All rights reserved.
 *
 */

#ifndef fixmem_vector_h
#define fixmem_vector_h

#include <iterator>

/**
 * fixmem_vector
 * T can not have destructor.
 * T have only primitive type member.
 */
template <typename T, size_t _Capacity>
struct fixmem_vector
{
    //
    // typedef
    //
    typedef T                               value_type; 
    typedef value_type&                     reference;
    typedef const value_type&               const_reference;
    typedef value_type*                     iterator;
    typedef const value_type*               const_iterator;
    typedef value_type*                     pointer;
    typedef std::size_t                     size_type;
    typedef std::ptrdiff_t                  difference_type;
    typedef const value_type*               const_pointer;
    //
    // member variable
    //
    value_type                              _elems[_Capacity > 0 ? _Capacity : 1];
    pointer                                 _end = _elems;
    //
    // method
    //
    iterator begin() noexcept { 
        return iterator(_elems);
    }
    const_iterator begin() const noexcept { 
        return const_iterator(_elems);
    }
    iterator end() noexcept {
        return iterator(_end);
    }
    const_iterator end() const noexcept {
        return const_iterator(_end); 
    }
    const_iterator cbegin() const noexcept { return begin(); }
    const_iterator cend() const noexcept { return end(); }
    
    size_type size() const noexcept { return _end - _elems; }
    size_type capacity() const noexcept { return _Capacity; }
    bool empty() const noexcept { return _end == _elems; }
    
    // true:  success
    // false: full error
    bool push_back(const_reference x){
        if (_end == _elems + _Capacity){
            // full error
            return false;
        }
        *_end = x;
        ++_end;
        return true;
    }
    // true:  success
    // false: full error
    bool push_back(value_type&& x)
    {
        if (_end == _elems + _Capacity){
            // full error
            return false;
        }
        *(_end++) = x;
        return true;
    }
    iterator erase(const_iterator __position)
    {
        assert(__position != end());
        
        difference_type ps = __position - cbegin();
        pointer p = _elems + ps;
        iterator r = iterator(p);
        pointer end = _end - 1;
        pointer q = p;
        while (q != end){
            *q = *(q+1);
            ++q;
        }
        --_end;
        return r;
    }
    void clear() noexcept {
        _end = _elems;
    }
};

#endif // fixmem_vector_h
