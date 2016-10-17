//
//  CZJTestTableViewDataSource.h
//  CZJUnit
//
//  Created by isExist on 2016/10/5.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZJTestViewModel.h"

@class CZJTestNode;

@interface CZJTestTableViewDataSource : CZJTestViewModel <UITableViewDataSource>

- (CZJTestNode *)nodeForIndexPath:(NSIndexPath *)indexPath;

- (NSArray<CZJTestNode *> *)nodesForIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (CZJTestNode *)nodeWithChildrenAnIndexpaths:(NSArray<NSIndexPath *> *)indexPaths;

@end
