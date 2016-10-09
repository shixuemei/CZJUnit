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

@interface CZJTestMainViewController () <UITableViewDelegate> {
    UIBarButtonItem *_testCtrlButton;
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
    
    _testCtrlButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStylePlain target:self action:@selector(toggleCtrlButton)];
    self.navigationItem.rightBarButtonItem = _testCtrlButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CZJTestTableViewDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[CZJTestTableViewDataSource alloc] initWithIdentifier:@"Tests" suite:[CZJTestSuite suiteFromEnv]];
        [_dataSource loadDefaults];
    }
    
    return _dataSource;
}

#pragma mark - UITabelViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CZJTestViewController *testVC = [[CZJTestViewController alloc] init];
    
    CZJTestNode *sectionNode = _dataSource.root.children[indexPath.section];
    CZJTestNode *testNode = sectionNode.children[indexPath.row];
    [testVC setTest:testNode.test];
    
    [self.navigationController pushViewController:testVC animated:YES];
    [_mainView.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (void)toggleCtrlButton {
    
}

@end
