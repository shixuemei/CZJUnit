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
    NSMutableArray<CZJTestNode *> *_filteredChildren;
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
    if (_filter != CZJTestNodeFilterNone || _textFilter) {
        return _filteredChildren;
    }
    return _children;
}

- (NSString *)name {
    return [_test name];
}

- (NSString*)identifier {
    return [_test identifier];
}

- (void)setFilter:(CZJTestNodeFilter)filter textFilter:(NSString *)textFilter {
    _filter = filter;
    
    textFilter = [textFilter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([textFilter isEqualToString:@""]) {
        textFilter = nil;
    }
    
    _textFilter = [textFilter lowercaseString];
    [self applyFilters];
}

- (void)setFilter:(CZJTestNodeFilter)filter {
    [self setFilter:filter textFilter:_textFilter];
}

- (void)setTextFilter:(NSString *)textFilter {
    [self setFilter:_filter textFilter:textFilter];
}

- (BOOL)hasChildren {
    return self.children.count > 0;
}

#pragma mark - Private methods

- (void)applyFilters {
    NSMutableSet *textFiltered = [NSMutableSet set];
    for (CZJTestNode *childNode in _children) {
        childNode.textFilter = _textFilter;
        if (_textFilter) {
            if ([[self.name lowercaseString] containsString:_textFilter]
                || [[childNode.name lowercaseString] containsString:_textFilter]
                || [childNode hasChildren]) {
                [textFiltered addObject:childNode];
            }
        }
    }
    
    _filteredChildren = [NSMutableArray array];
    for(CZJTestNode *childNode in _children) {
        if (!_textFilter || [textFiltered containsObject:childNode]) {
            [_filteredChildren addObject:childNode];
        }
    }
}

@end
