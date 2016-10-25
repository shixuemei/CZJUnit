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
const CGFloat kSearchBarHeight = 40.f;

@interface CZJTestMainView ()

@property (nonatomic, strong) UITableView *         tableView;
@property (nonatomic, strong) UISegmentedControl *  segmentedControl;
@property (nonatomic, strong) UISearchBar *         searchBar;
@property (nonatomic, strong) UITextView *          logView;

@end

@implementation CZJTestMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _logView = [[UITextView alloc] init];
        _logView.editable = NO;
        [self addSubview:_logView];
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All", @"Failed"]];
        _segmentedControl.selectedSegmentIndex = 0;
        [self addSubview:_segmentedControl];

        _searchBar = [[UISearchBar alloc] init];
        [self addSubview:_searchBar];

        _tableView = [[UITableView alloc] init];
        [self addSubview:_tableView];
        
        [_segmentedControl addObserver:self
                            forKeyPath:@"selectedSegmentIndex"
                               options:NSKeyValueObservingOptionNew
                               context:nil];
    }
    return self;
}

- (void)dealloc {
    [_segmentedControl removeObserver:self forKeyPath:@"selectedSegmentIndex"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UISegmentedControl class]]) {
        if ([keyPath isEqualToString:@"selectedSegmentIndex"]) {
            if ([_searchBar.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
                [_searchBar.delegate searchBar:_searchBar textDidChange:@""];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    CGFloat originY = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ? 64.f : 32.f;
    
    CGRect segFrame = CGRectMake(frame.origin.x + kHorizenSpacing,
                                 frame.origin.y + frame.size.height - kVerticalSpacing - kSegmentedControlHeight,
                                 MAINSCREEN_WIDTH - 2 * kHorizenSpacing,
                                 kSegmentedControlHeight);
    _segmentedControl.frame = segFrame;
    
    CGRect searchBarFrame = CGRectMake(frame.origin.x,
                                       frame.origin.y + originY,
                                       MAINSCREEN_WIDTH,
                                       kSearchBarHeight);
    _searchBar.frame = searchBarFrame;
    
    CGRect tableFrame = CGRectMake(frame.origin.x,
                                   searchBarFrame.origin.y + kSearchBarHeight,
                                   MAINSCREEN_WIDTH,
                                   segFrame.origin.y - kVerticalSpacing - searchBarFrame.origin.y - searchBarFrame.size.height);
    _tableView.frame = tableFrame;
    
    _logView.frame = CGRectMake(0, originY, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - originY);
}

- (void)showLogViewWithContent:(NSString *)content {
    _logView.text = content;
    [self bringSubviewToFront:_logView];
}

- (void)closeLogView {
    [self sendSubviewToBack:_logView];
}

@end
