//
//  CZJTestMainViewController.m
//  CZJTest
//
//  Created by isExist on 2016/9/23.
//  Copyright © 2016年 isExist. All rights reserved.
//

#import "CZJTestMainViewController.h"
#import "CZJTestViewController.h"
#import "CZJTestMainView.h"
#import "CZJTestCaseCell.h"
#import "CZJTesting.h"
#import "CZJTestTableViewDataSource.h"
#import "CZJTestSuite.h"
#import "CZJTestRunner.h"

@interface CZJTestMainViewController () <UITableViewDelegate, CZJTestDisplayDelegate> {
    UIBarButtonItem *_testCtrlButton;
    UIBarButtonItem *_testMarkButton;
    CZJTestMainView *_mainView;
}

@property (nonatomic, strong) CZJTestTableViewDataSource *dataSource;

@end

@implementation CZJTestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainView = [[CZJTestMainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_mainView];
    self.title = @"Test";
    
    _mainView.tableView.delegate = self;
    _mainView.tableView.dataSource = self.dataSource;
    _mainView.tableView.allowsMultipleSelection = YES;
    
    _testCtrlButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStylePlain target:self action:@selector(toggleCtrlButton)];
    _testMarkButton = [[UIBarButtonItem alloc] initWithTitle:@"Mark" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMarkButton)];
    self.navigationItem.rightBarButtonItems = @[_testCtrlButton, _testMarkButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CZJTestTableViewDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[CZJTestTableViewDataSource alloc] initWithIdentifier:@"Tests"
                                                                       suite:[CZJTestSuite suiteFromEnv]];
        [_dataSource loadDefaults];
    }
    
    return _dataSource;
}

#pragma mark - UITabelViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_mainView.tableView.isEditing) {
        CZJTestNode *testNode = [self.dataSource nodeForIndexPath:indexPath];
        
        CZJTestViewController *testVC = [[CZJTestViewController alloc] init];
        [testVC setTest:testNode.test];
        
        [self.navigationController pushViewController:testVC animated:YES];
        [_mainView.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - CZJTestDisplayDelegate

- (void)willDisplayTest:(id<CZJTest>)test {
    CZJTestViewController *testVC = [[CZJTestViewController alloc] init];
    [testVC setTest:test];
    
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)didDisplayTest:(id<CZJTest>)test {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)toggleCtrlButton {
    if (_mainView.tableView.isEditing) {
        NSArray *indexPaths = _mainView.tableView.indexPathsForSelectedRows;
        for (NSIndexPath *indexPath in indexPaths) {
            CZJTestNode *node = [self.dataSource nodeForIndexPath:indexPath];
            [[CZJTestRunner sharedRunner] runTest:node.test
                                      withOptions:CZJTestOptionNone
                                      inDisplayer:self];
        }
    } else {
        [[CZJTestRunner sharedRunner] runTest:self.dataSource.root.test
                                  withOptions:CZJTestOptionNone
                                  inDisplayer:self];
    }
}

- (void)toggleMarkButton {
    _mainView.tableView.editing = !_mainView.tableView.isEditing;
    _testMarkButton.title = _mainView.tableView.isEditing ? @"Done" : @"Mark";
}

@end
