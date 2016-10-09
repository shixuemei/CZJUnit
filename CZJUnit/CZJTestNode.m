//
//  CZJTestNode.m
//  CZJUnit
//
//  Created by isExist on 2016/9/29.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestNode.h"
#import "CZJTestGroup.h"

@implementation CZJTestNode {
    NSMutableArray<CZJTestNode *> *_children;
}

@synthesize children = _children;

- (instancetype)initWithTest:(id<CZJTest>)test children:(NSArray<id<CZJTest>> *)children source:(CZJTestViewModel *)source {
    if (self = [self init]) {
        _test = test;
        
        NSMutableArray *childNodes = [NSMutableArray array];
        for (id<CZJTest> childTest in children) {
            CZJTestNode *node = nil;
            if ([childTest conformsToProtocol:@protocol(CZJTestGroup)]) {
                NSArray *childrenOfChild = [(id<CZJTestGroup>)childTest children];
                if (childrenOfChild.count > 0) {
                    node = [CZJTestNode nodeWithTest:childTest children:childrenOfChild source:source];
                }
            } else {
                node = [CZJTestNode nodeWithTest:childTest children:nil source:source];
            }
            if (node) {
                [childNodes addObject:node];
            }
        }
        
        _children = childNodes;
        
        
    }
    
    return self;
}

+ (instancetype)nodeWithTest:(id<CZJTest>)test children:(NSArray<id<CZJTest>> *)children source:(CZJTestViewModel *)source {
    return [[CZJTestNode alloc] initWithTest:test children:children source:source];
}

- (NSArray<CZJTestNode *> *)children {
    return _children;
}

- (NSString *)name {
    return [_test name];
}

- (NSString*)identifier {
    return [_test identifier];
}

@end
