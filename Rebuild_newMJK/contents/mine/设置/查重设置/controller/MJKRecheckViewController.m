//
//  MJKRecheckViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/8.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKRecheckViewController.h"
#import "MJKCustomReturnSubModel.h"

#import "MJKRecheckTableViewCell.h"

@interface MJKRecheckViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJKRecheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"潜客查重设置";
    [self HTTPRecheckSetDatas];
    [self.view addSubview:self.tableView];
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    MJKRecheckTableViewCell *cell = [MJKRecheckTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = model.C_NAME;
    cell.switchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"] ? NO : YES;
    cell.switchButtonActionBlock = ^{
        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
        } else {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
        }
        [weakSelf httpSetRecheck:model];
    };
    return cell;
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

//MARK:-http
- (void)HTTPRecheckSetDatas {
	DBSelf(weakSelf);
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"TYPE"] = @"5";
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
//    DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
	NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            if ([model.C_NAME isEqualToString:@"可选择预先维护的楼盘名称"]) {
                if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                    [NewUserSession instance].configData.IS_KHXQDZ = @"1";
                } else if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"]) {
                    [NewUserSession instance].configData.IS_KHXQDZ = @"0";
                }
            }
			[JRToast showWithText:@"操作成功"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
