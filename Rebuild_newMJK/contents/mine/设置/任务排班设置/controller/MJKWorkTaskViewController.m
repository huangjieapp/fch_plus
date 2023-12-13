//
//  MJKWorkTaskViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkTaskViewController.h"

#import "MJKSetWorkTaskCell.h"

#import "MJKClueListSubModel.h"
#import "MJKCustomReturnSubModel.h"

@interface MJKWorkTaskViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *reModel;
/** xremark*/
@property (nonatomic, strong) NSString *x_remark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation MJKWorkTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = SafeAreaTopHeight;
	self.title = @"任务排班公示设置";
	[self requestAllDatas];
}

- (void)requestAllDatas {
	DBSelf(weakSelf);
	[self getSalesListDatas];
	[self HTTPSafeSetDatasCompleteBlock:^(MJKCustomReturnSubModel *model) {
		weakSelf.reModel = model;
		weakSelf.switchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
		weakSelf.tableView.hidden = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? NO : YES;
	}];
}

- (IBAction)openSwitchButtonAction:(UISwitch *)sender {
	self.tableView.hidden = sender.isOn == YES ? NO : YES;
	self.reModel.C_STATUS_DD_ID = sender.isOn == YES ? @"A47500_C_STATUS_0000" : @"A47500_C_STATUS_0001";
	[self httpSetSafeWithModel:self.reModel];
}

//MARK:- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKClueListSubModel *model = self.dataArray[indexPath.row];
	MJKSetWorkTaskCell *cell = [MJKSetWorkTaskCell cellWithTableView:tableView];
	cell.model = model;
	cell.backSelectBlock = ^{
		NSMutableArray *arr = [NSMutableArray array];
		for (MJKClueListSubModel *model in self.dataArray) {
			if (model.isSelected == YES) {
				[arr addObject:model.user_id];
			}
		}
		weakSelf.x_remark = [arr componentsJoinedByString:@","];
		[weakSelf httpSetSafeWithModel:weakSelf.reModel];
	};
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}


//MARK:-http data
-(void)getSalesListDatas {
	DBSelf(weakSelf);
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		//        DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKClueListSubModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
	
}

- (void)HTTPSafeSetDatasCompleteBlock:(void(^)(MJKCustomReturnSubModel *model))successBlock {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"TYPE"] = @"4";
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray *array = data[@"data"][@"content"];
			for (NSDictionary *dic in array) {
				MJKCustomReturnSubModel *safeModel = [MJKCustomReturnSubModel yy_modelWithDictionary:dic];
				if (successBlock) {
					successBlock(safeModel);
				}
			}
			
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

-(void)httpSetSafeWithModel:(MJKCustomReturnSubModel *)model {
		DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
	NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_ID"] = model.C_ID;
	contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
	if (self.x_remark.length > 0) {
		contentDict[@"X_REMARK"] = self.x_remark;
	}
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                [NewUserSession instance].configData.IS_RWPB = @"1";
            } else {
                [NewUserSession instance].configData.IS_RWPB = @"0";
            }
			weakSelf.x_remark = @"";
            [weakSelf getSalesListDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
}

@end
