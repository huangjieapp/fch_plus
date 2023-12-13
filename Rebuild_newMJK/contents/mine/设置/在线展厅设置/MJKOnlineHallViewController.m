//
//  MJKOnlineHallViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineHallViewController.h"
#import "MJKOnlineHallDetailViewController.h"

#import "MJKFlowInstrumentModel.h"
#import "MJKFlowInstrumentSubModel.h"

#import "MJKOnlineHallTableViewCell.h"

#import "MJKSettingHeadView.h"

//#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MJKOnlineHallViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) MJKFlowInstrumentModel *onlineModel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) MJKSettingHeadView *headView;
@end

@implementation MJKOnlineHallViewController
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//    [self HTTPGetOnlineHallDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.onlineModel = [[MJKFlowInstrumentModel alloc]init];
    [self.view addSubview:self.headView];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.addButton];
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowInstrumentSubModel *subModel = self.onlineModel.content[indexPath.row];
	MJKOnlineHallTableViewCell *cell = [MJKOnlineHallTableViewCell cellWithTableView:tableView];
	cell.model = subModel;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSURL *url = [NSURL URLWithString:@"http://hls01open.ys7.com/openlive/caae0e55eab64e39aa7cf5df23417ed1.m3u8"];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
    //步骤1：获取视频路径
    NSString *webVideoPath = @"http://hls01open.ys7.com/openlive/caae0e55eab64e39aa7cf5df23417ed1.m3u8";
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    
//    MJKFlowInstrumentSubModel *subModel = self.onlineModel.content[indexPath.row];
//    MJKOnlineHallDetailViewController *detailVC = [[MJKOnlineHallDetailViewController alloc]init];
//    detailVC.model = subModel;
//    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[weakSelf HTTPGetOnlineHallDatas];
		
		
		[weakSelf.tableView.mj_header endRefreshing];
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPGetOnlineHallDatas];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark - 点击事件
- (void)addButtonAction:(UIButton *)sender {
	MJKOnlineHallDetailViewController *detailVC = [[MJKOnlineHallDetailViewController alloc]init];
	detailVC.isAdd = YES;
	[self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - HTTP request
- (void)HTTPGetOnlineHallDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getFlowSetList];
	[dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",self.pages], @"pageSize" : [NSString stringWithFormat:@"%ld",self.pagen], @"TYPE" : @"3"} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.onlineModel = [MJKFlowInstrumentModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - self.headView.frame.size.height) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

- (UIButton *)addButton {
	if (!_addButton) {
		_addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 40) / 2, KScreenHeight - 40 - 10, 40, 40)];
		[_addButton setBackgroundImage:[UIImage imageNamed:@"addimg.png"] forState:UIControlStateNormal];
		[_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_addButton];
	}
	return _addButton;
}

- (MJKSettingHeadView *)headView {
    if (!_headView) {
        _headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
        _headView.headTitleArray = @[@"设备类型", @"位置", @"操作"];
    }
    return _headView;
}
@end
