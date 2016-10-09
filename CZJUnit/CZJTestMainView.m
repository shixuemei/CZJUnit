//
//  CZJTestMainView.m
//  CZJTest
//
//  Created by isExist on 2016/9/27.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestMainView.h"

#define MAINSCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

const CGFloat kVerticalSpacing = 5.f;
const CGFloat kHorizenSpacing = 5.f;
const CGFloat kSegmentedControlHeight = 30.f;

@interface CZJTestMainView ()

@property (nonatomic, strong) UITableView *         tableView;
@property (nonatomic, strong) UISegmentedControl *  segmentedControl;

@end

@implementation CZJTestMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect segFrame = CGRectMake(kHorizenSpacing,
                                     MAINSCREEN_HEIGHT - kVerticalSpacing - kSegmentedControlHeight,
                                     MAINSCREEN_WIDTH - 2 * kHorizenSpacing,
                                     kSegmentedControlHeight);
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All", @"Failed"]];
        _segmentedControl.frame = segFrame;
        _segmentedControl.selectedSegmentIndex = 0;
        [self addSubview:_segmentedControl];
        
        CGRect tableFrame = CGRectMake(0, 64, MAINSCREEN_WIDTH, segFrame.origin.y - kVerticalSpacing - 64);
        _tableView = [[UITableView alloc] initWithFrame:tableFrame];
        [self addSubview:_tableView];
    }
    return self;
}

@end
