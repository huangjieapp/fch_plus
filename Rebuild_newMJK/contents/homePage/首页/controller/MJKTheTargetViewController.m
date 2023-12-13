//
//  MJKTheTargetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTheTargetViewController.h"

#import "MJKYJTableViewCell.h"

#import "MJKHomePageJXModel.h"

@interface MJKTheTargetViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSArray *jxArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;


@end

@implementation MJKTheTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
    
    self.title = [NSString stringWithFormat:@"%@目标",self.titleStr];
    [self getJXDatas];
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.jxArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKHomePageJXModel *model = self.jxArray[indexPath.row];
    MJKYJTableViewCell *cell = [MJKYJTableViewCell cellWithTableView:tableView];
    cell.model = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}
//MARK:-set
-(void)getJXDatas{
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70900WebService-getJxrptByType"];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = @"yyyy-MM";
    NSString *ym = [df stringFromDate:[NSDate date]];
    [dict setObject:@{@"type" : self.type, @"C_YEARMONTH" : ym} forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.jxArray = [MJKHomePageJXModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
