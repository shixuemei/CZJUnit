//
//  CZJTestGroup.h
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTest.h"
#import "CZJTestCase.h"

@protocol CZJTestGroup <CZJTest>

@property (nonatomic, weak) id<CZJTestGroup> parent;

@property (nonatomic, strong, readonly) NSArray<id<CZJTest>> *children;

@end

@interface CZJTestGroup : NSObject <CZJTestGroup, CZJTestDelegate>

@property (nonatomic, strong, readonly) id testCase;

/*!
 Create an empty test group.
 @param name The name of the test group
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithName:(NSString *)name delegate:(id<CZJTestDelegate>)delegate;

/*!
 Create test group from a test case.
 @param testCase Test case, a subclass of GHTestCase
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithTestCase:(id)testCase delegate:(id<CZJTestDelegate>)delegate;

/*!
 Add test to this group.
 @param test Test to add
 */
- (void)addTest:(id<CZJTest>)test;

/*!
 Add tests to this group.
 @param tests Tests to add
 */
- (void)addTests:(NSArray<id<CZJTest>> *)tests;

/*!
 Add a test case (or test group) to this test group.
 @param testCase Test case, should be a subclass of CZJTestCase
 */
- (void)addTestCase:(id)testCase;

/*!
 Add a test group to this test group.
 @param testGroup Test group to add
 */
- (void)addTestGroup:(CZJTestGroup *)testGroup;

@end
