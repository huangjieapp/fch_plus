//
//  MJKTaskNewWorkListController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTaskNewWorkListController.h"
#import "ServiceTaskWorkListViewController.h"

#import "MJKTaskWorkListModel.h"

#import "MJKTaskNewWorkListCell.h"

@interface MJKTaskNewWorkListController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *weakArray;
@end

@implementation MJKTaskNewWorkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLayout.constant = SafeAreaTopHeight;
    self.bottomLayout.constant = SafeAreaBottomHeight;
    
    self.title = @"任务排班列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < self.weakArray.count; i++) {
        UILabel *label = self.weakArray[i];
        NSString *timerStr = [DBTools getWeeksFomatFromCurrentTimeStampWithDays:i * 60 * 60 * 24];
        label.text = [timerStr substringFromIndex:11];
    }
    
    [self httpGetTaskListData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskWorkListModel *model = self.dataArray[indexPath.row];
    MJKTaskNewWorkListCell *cell = [MJKTaskNewWorkListCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskWorkListModel *model = self.dataArray[indexPath.row];
    ServiceTaskWorkListViewController *vc = [[ServiceTaskWorkListViewController alloc]init];
    vc.userid = model.USERID;
    vc.STATUS_TYPE = @"6";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

//MARK:-http request
- (void)httpGetTaskListData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A01200WebService-getRwFb"];
    [dict setObject:@{} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKTaskWorkListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

@end
