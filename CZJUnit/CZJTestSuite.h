//
//  CZJTestSuite.h
//  CZJUnit
//
//  Created by isExist on 2016/10/5.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestGroup.h"

@interface CZJTestSuite : CZJTestGroup

/*!
 Create test suite with test cases.
 @param name Label to give the suite
 @param testCases Array of init'ed test case classes
 @param delegate Delegate
 */
- (id)initWithName:(NSString *)name testCases:(NSArray *)testCases delegate:(id<CZJTestDelegate>)delegate;

/*!
 Return test suite based on environment (TEST=TestFoo/foo)
 @result Suite
 */
+ (instancetype)suiteFromEnv;

/*!
 Creates a suite of all tests.
 Will load all classes that subclass from CZJTestCase (or register test case class).
 @result Suite
 */
+ (instancetype)allTests;

@end
