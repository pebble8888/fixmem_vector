//
//  fixmem_vector_test.mm
//
//  Created by pebble8888 on 2016/09/03.
//  Copyright © 2016 pebble8888. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "fixmem_vector.h"
#include <algorithm>

@interface fixmem_vector_test : XCTestCase
@end

@implementation fixmem_vector_test

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test1 {
    fixmem_vector<int32_t, 8> _v;
    
    XCTAssert(_v.empty());
    XCTAssert(_v.capacity() == 8);
    
    // rvalue
    XCTAssert(_v.push_back(2));
    XCTAssert(_v.push_back(3));
    XCTAssert(_v.push_back(5));
    XCTAssert(_v.push_back(7));
    
    XCTAssert(_v.size() == 4);
    
    int i;
    i = 0;
    for (auto j: _v){
        switch(i){
            case 0: XCTAssert(j == 2); break;
            case 1: XCTAssert(j == 3); break;
            case 2: XCTAssert(j == 5); break;
            case 3: XCTAssert(j == 7); break;
            default: XCTFail();
        }
        ++i;
    }
    
    i = 0;
    auto it = _v.begin();
    for(; it != _v.end(); ++it){
        switch(i){
            case 0: XCTAssert((*it) == 2); break;
            case 1: XCTAssert((*it) == 3); break;
            case 2: XCTAssert((*it) == 5); break;
            case 3: XCTAssert((*it) == 7); break;
            default: XCTFail();
        }
        ++i;
    }
    
    i = 0;
    it = _v.begin();
    for (; it != _v.end();){
        if (i == 1){
            it = _v.erase(it);
        } else {
            ++it;
        }
        ++i;
    }
    
    XCTAssert(_v.size() == 3);
    
    i = 0;
    fixmem_vector<int32_t, 8>::const_iterator cit = _v.cbegin();
    while (cit != _v.cend()){
        switch(i){
            case 0: XCTAssert((*cit) == 2); break;
            case 1: XCTAssert((*cit) == 5); break;
            case 2: XCTAssert((*cit) == 7); break;
            default: XCTFail();
        }
        ++cit;
        ++i;
    }
    
    _v.clear();
    XCTAssert(_v.empty());
}

- (void)testLvaluePushBackAndOverflow {
    fixmem_vector<int32_t, 3> _v;
    
    const int32_t& r = 2;
    // lvalue
    XCTAssert(_v.push_back(r));
    XCTAssert(_v.size() == 1);
    
    XCTAssert(_v.push_back(r));
    XCTAssert(_v.size() == 2);
    
    XCTAssert(_v.push_back(r));
    XCTAssert(_v.size() == 3);
    
    XCTAssertFalse(_v.push_back(r));
    XCTAssert(_v.size() == 3);
}

- (void)testRvaluePushBackAndOverflow {
    fixmem_vector<int32_t, 3> _v;
   
    // rvalue
    XCTAssert(_v.push_back(2));
    XCTAssert(_v.size() == 1);
    
    XCTAssert(_v.push_back(3));
    XCTAssert(_v.size() == 2);
    
    XCTAssert(_v.push_back(5));
    XCTAssert(_v.size() == 3);
    
    XCTAssertFalse(_v.push_back(7));
    XCTAssert(_v.size() == 3);
}

- (void)testLowerBoundPrimitive {
    fixmem_vector<int32_t,8> _v;

    _v.push_back(1);
    _v.push_back(3);
    _v.push_back(3);
    _v.push_back(5);
    _v.push_back(5);
    _v.push_back(7);
    
    auto it = std::lower_bound(_v.begin(), _v.end(), 3);
    XCTAssert((*it) == 3);
    auto jt = std::lower_bound(_v.begin(), _v.end(), 4);
    XCTAssert((*jt) == 5);
}

- (void)testLowerBoundStruct {
    struct Info {
        int32_t idx;
        double  data;
        Info() {}
        Info(const Info& obj) :idx(obj.idx), data(obj.data) {}
        Info(Info& obj) : idx(obj.idx), data(obj.data) {}
        Info(int32_t a_idx, double a_data) :idx(a_idx) ,data(a_data) {}
        
        static bool compare(const Info& a, const Info& b){
            return a.idx < b.idx;
        }
    };
    
    fixmem_vector<Info,8> _v;

    _v.push_back(Info(1, 2.1));
    _v.push_back(Info(3, 5.2));
    _v.push_back(Info(3, 8.9));
    _v.push_back(Info(5, 0.1));
    _v.push_back(Info(5, 4.1));
    _v.push_back(Info(7, 5.5));
    
    Info t1(3, 0);
    auto it = std::lower_bound(_v.begin(), _v.end(), t1, Info::compare);
    XCTAssert((*it).idx == 3);
    
    Info t2(4, 0);
    auto jt = std::lower_bound(_v.begin(), _v.end(), t2, Info::compare);
    XCTAssert((*jt).idx == 5);
}

@end
