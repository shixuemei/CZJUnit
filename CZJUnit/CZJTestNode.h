//
//  CZJTestNode.h
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CZJTest;

@class CZJTestNode;
@class CZJTestViewModel;

typedef NS_ENUM(NSInteger, CZJTestNodeFilter) {
    CZJTestNodeFilterNone = 0,
    CZJTestNodeFilterFailed = 1
};

@protocol CZJTestNodeDelegate <NSObject>

- (void)testNodeDidChange:(CZJTestNode *)node;

@end

@interface CZJTestNode : NSObject

@property (nonatomic, strong, readonly) id<CZJTest> test;

@property (nonatomic, strong, readonly) NSArray<CZJTestNode *> *children;

@property (nonatomic, weak) id<CZJTestNodeDelegate> delegate;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSString *identifier;

@property (nonatomic, assign) CZJTestNodeFilter filter;

@property (nonatomic, copy) NSString *textFilter;

@property (nonatomic, assign, readonly, getter=isFailed) BOOL failed;

- (instancetype)initWithTest:(id<CZJTest>)test
                    children:(NSArray<id<CZJTest>> *)children
                      source:(CZJTestViewModel *)source;

+ (instancetype)nodeWithTest:(id<CZJTest>)test
                    children:(NSArray<id<CZJTest>> *)children
                      source:(CZJTestViewModel *)source;

- (void)setFilter:(CZJTestNodeFilter)filter textFilter:(NSString *)textFilter;

- (BOOL)hasChildren;

@end
