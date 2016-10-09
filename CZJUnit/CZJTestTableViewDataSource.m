//
//  CZJTestTableViewDataSource.m
//  CZJUnit
//
//  Created by isExist on 2016/10/5.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestTableViewDataSource.h"
#import "CZJTestNode.h"

static NSString *kCellIdentifier = @"identifier";

@implementation CZJTestTableViewDataSource

- (CZJTestNode *)nodeForIndexPath:(NSIndexPath *)indexPath {
    CZJTestNode *sectionNode = self.root.children[indexPath.section];
    return sectionNode.children[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfTestsInGroup:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = [self numberOfGroups];
    return MAX(numberOfSections, 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *children = self.root.children;
    if (children.count == 0) {
        return nil;
    }
    
    CZJTestNode *sectionNode = children[section];
    return sectionNode.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CZJTestNode *sectionNode = self.root.children[indexPath.section];
    CZJTestNode *node = sectionNode.children[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", node.name];
    
    return cell;
}

@end
