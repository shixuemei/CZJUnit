//
//  CZJTestViewModel.h
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZJTestNode.h"

@class CZJTestSuite;

@interface CZJTestViewModel : NSObject <CZJTestNodeDelegate>

@property (nonatomic, readonly) NSString *identifier;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, strong, readonly) CZJTestNode *root;

- (instancetype)initWithIdentifier:(NSString *)identifier suite:(CZJTestSuite *)suite;

- (NSInteger)numberOfGroups;

- (NSInteger)numberOfTestsInGroup:(NSInteger)group;

/*!
 Load defaults (user settings saved with saveDefaults).
 */
- (void)loadDefaults;

/*!
 Register node, so that we can do a lookup later. See findTestNodeForTest:.
 
 @param node Node to register
 */
- (void)registerNode:(CZJTestNode *)node;

@end
