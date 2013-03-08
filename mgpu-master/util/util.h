#pragma once

#include <cassert>
#include <algorithm>
#include <cstdio>
#include <cstring>

// May include interlocked.hpp to support multi-threaded access to the CuBase 
// reference counter.
// #include <boost/detail/interlocked.hpp>

typedef unsigned char byte;
typedef unsigned int uint;
typedef unsigned long ulong;
typedef long long int64;
typedef unsigned long long uint64;

#ifdef _MSC_VER

#include <intrin.h>

inline int FindMaxBit(int x) {
	int bit;
	_BitScanReverse((ulong*)&bit, x);
	return bit;
}

#else 

inline int FindMaxBit(int x) {
	int bit = 0;
	while(x) {
		x>>= 1;
		++bit;
	}
	return bit;
}

#endif 

#define BIT(bit) (1<< bit)
#define MASK(high, low) (((31 == high) ? 0 : (1u<< (high + 1))) - (1<< low))
#define MASKSHIFT(high, low, x) ((MASK(high, low) & x) >> low)

template<typename T>
inline T DivUp(T num, T den) {
	return (num + den - 1) / den;
}
template<typename T>
T RoundUp(T x, T y) {
//	return x + ((y - x) % y);
	return ~(y - 1) & (x + y - 1);
}

template<typename T>
T RoundDown(T x, T y) {
	return ~(y - 1) & x;
}

// IsSameType is very useful
template<typename T, typename U>
struct IsSameType {
	enum { value = false };
};
template<typename T>
struct IsSameType<T, T> {
	enum { value = true };
};


typedef std::pair<int, int> IntPair;

// boost::noncopyable, moved here so we don't have dependency on boost
class noncopyable {
	protected:
		noncopyable() {}
		~noncopyable() {}
	private:  // emphasize the following members are private
		noncopyable( const noncopyable& );
		const noncopyable& operator=( const noncopyable& );
};

// single-threaded base class access
class CuBase : noncopyable {
public: 
	CuBase() : _ref(0) { }
	virtual ~CuBase() { }
	long AddRef() {
	//	return BOOST_INTERLOCKED_INCREMENT(&_ref);
		return ++_ref;
	}
	void Release() {
	//	if(!BOOST_INTERLOCKED_DECREMENT(&_ref)) delete this;
		if(!--_ref) delete this;		
	}
private:
	long _ref;
};

inline long intrusive_ptr_add_ref(CuBase* base) {
	return base->AddRef();
}

inline void intrusive_ptr_release(CuBase* base) {
	base->Release();
}


// same as intrusive_ptr but provides pointer conversion operator
template<typename T>
class intrusive_ptr2 {
public:
	intrusive_ptr2() : _p(0) { }
	intrusive_ptr2(T* p, bool addRef = true) : _p(p) {
		if(p && addRef) intrusive_ptr_add_ref(p);
	}

//	template<typename T2>
	intrusive_ptr2(const intrusive_ptr2& rhs) : _p(rhs._p) {
		if(_p) intrusive_ptr_add_ref(_p);
	}
	~intrusive_ptr2() {
		if(_p) intrusive_ptr_release(_p);
	}

	intrusive_ptr2& operator=(const intrusive_ptr2& rhs) {
		intrusive_ptr2(rhs.get()).swap(*this);
		return *this;
	}
	intrusive_ptr2& operator=(T* rhs) {
		intrusive_ptr2(rhs).swap(*this);
		return *this;
	}

	// allow conversion 
	void reset(T* p = 0) {
		intrusive_ptr2(p).swap(*this);
	}
	
	T* get() const { return _p; }
	operator T*() const { return _p; }
	T* operator->() const { return _p; }
	T* release() { 
		T* p = _p;
		_p = 0;
		return p;
	}

	void swap(intrusive_ptr2& rhs) {
		std::swap(_p, rhs._p);
	}

private:
	T* _p;
};

