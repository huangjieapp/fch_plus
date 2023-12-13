//
//  MJKFlowInstrumentViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowInstrumentViewController.h"

#import "MJKSettingHeadView.h"
#import "CGCAlertDateView.h"
#import "MJKFlowInstrumentTableViewCell.h"

#import "MJKFlowInstrumentModel.h"
#import "MJKFlowInstrumentSubModel.h"

#import "RecoLiveViw.h"
#import "MJKThreeAlertView.h"

@interface MJKFlowInstrumentViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewTopLayout;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) MJKFlowInstrumentModel *flowModel;
@property (nonatomic, strong) MJKFlowInstrumentSubModel *subModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
/** <#注释#>*/
@property (nonatomic, strong) MJKThreeAlertView *alertView;
@end

@implementation MJKFlowInstrumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.headViewTopLayout.constant = NavStatusHeight;
	[self.headTitleArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.text = @[@"序号", @"设备类型", @"位置", @"操作"][idx];
	}];
	
//    = [NSArray arrayWithObjects:@"序号", @"设备类型", @"位置", @"操作", nil ];
//    [self.view addSubview:self.headView];
//	NSArray *array = @[@"序号", @"设备类型", @"位置", @"操作"];
//	self.headView.headTitleArray = array;
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.addButton];
	self.pagen = 20;
	[self setUpRefresh];
	[self HTTPGetFlowInstruMentDatas];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.flowModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	self.subModel = self.flowModel.content[indexPath.row];
	MJKFlowInstrumentTableViewCell *cell = [MJKFlowInstrumentTableViewCell cellWithTableView:tableView];
	cell.model = self.subModel;
	[cell setClickEditButtonBlock:^{
		[weakSelf clickEditButton:indexPath.row];
	}];
	[cell setClickDeleteButtonBlock:^{
		[weakSelf clickDeleteButton:indexPath.row];
	}];
	cell.liveButton.tag = indexPath.row + 3000;
	[cell.liveButton addTarget:self action:@selector(liveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[weakSelf HTTPGetFlowInstruMentDatas];
		
		
		[weakSelf.tableView.mj_header endRefreshing];
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPGetFlowInstruMentDatas];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark - 点击事件
- (void)addButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
    MJKThreeAlertView *alertView = [[MJKThreeAlertView alloc]initWithFrame:self.view.frame withTitle:@"新增人脸识别" withText:@"请填写设备信息" withTFTextArray:@[] withPlaceholder:@[@"请输入设备号",@"请输入位置信息",@"请选择位置"] withButtonArray:@[@"取消",@"确定"]];
    self.alertView = alertView;
    alertView.dataArray = @[@"请选择",@"入口", @"出口"];
    alertView.buttonActionBlock = ^(NSString * _Nonnull buttonType, NSString * _Nonnull numberStr, NSString * _Nonnull postionInfoStr, NSString * _Nonnull postionStr) {
        if ([buttonType isEqualToString:@"确定"]) {
         
            if ([weakSelf.title isEqualToString:@"人脸识别设置"]) {
                if (weakSelf.subModel == nil) {
                    weakSelf.subModel = [[MJKFlowInstrumentSubModel alloc]init];
                }
            }
            weakSelf.subModel.C_NUMBER = numberStr;
            weakSelf.subModel.C_POSITION = postionStr;
            weakSelf.subModel.X_REMARK = postionInfoStr;
            weakSelf.pagen = 20;
            [weakSelf HTTPInsertFlowInstruMentDatas];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
//    CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height / 2 - 100, KScreenWidth - 30, 200) withSelClick:^{
//
//    } withSureClick:^(NSString *title, NSString *dateStr) {
//        if ([weakSelf.title isEqualToString:@"人脸识别设置"]) {
//            if (weakSelf.subModel == nil) {
//                weakSelf.subModel = [[MJKFlowInstrumentSubModel alloc]init];
//            }
//        }
//        weakSelf.subModel.C_NUMBER = title;
//        weakSelf.subModel.C_POSITION = dateStr;
//        weakSelf.pagen = 20;
//        [weakSelf HTTPInsertFlowInstruMentDatas];
//    } withHight:192 withText:@"请填写设备信息" withDatas:nil];
//    alertDateView.titleLabel.text = @"新增人脸识别";
//    alertDateView.modelTextField.placeholder = @"请输入设备号";
//    alertDateView.remarkText.placeholder = @"请输入位置";
//    [self.view addSubview:alertDateView];
	
}

- (void)clickEditButton:(NSInteger)row {
	DBSelf(weakSelf);
	self.subModel = self.flowModel.content[row];
    MJKThreeAlertView *alertView = [[MJKThreeAlertView alloc]initWithFrame:self.view.frame withTitle:@"新增人脸识别" withText:@"请填写设备信息" withTFTextArray:@[self.subModel.C_NUMBER, self.subModel.X_REMARK, self.subModel.C_POSITION] withPlaceholder:@[@"请输入设备号",@"请输入位置信息",@"请选择位置"] withButtonArray:@[@"取消",@"确定"]];
    self.alertView = alertView;
    alertView.dataArray = @[@"请选择",@"入口", @"出口"];
    alertView.buttonActionBlock = ^(NSString * _Nonnull buttonType, NSString * _Nonnull numberStr, NSString * _Nonnull postionInfoStr, NSString * _Nonnull postionStr) {
        if ([buttonType isEqualToString:@"确定"]) {
            
            if ([weakSelf.title isEqualToString:@"人脸识别设置"]) {
                if (weakSelf.subModel == nil) {
                    weakSelf.subModel = [[MJKFlowInstrumentSubModel alloc]init];
                }
            }
            weakSelf.subModel.C_NUMBER = numberStr;
            weakSelf.subModel.C_POSITION = postionStr;
            weakSelf.subModel.X_REMARK = postionInfoStr;
            weakSelf.pagen = 20;
            [weakSelf HTTPChangeFlowInstruMentDatas];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
//    CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height / 2 - 100, KScreenWidth - 30, 200) withSelClick:^{
//
//    } withSureClick:^(NSString *title, NSString *dateStr) {
//        weakSelf.subModel.C_NUMBER = title;
//        weakSelf.subModel.C_POSITION = dateStr;
//        weakSelf.pagen = 20;
//        [weakSelf HTTPChangeFlowInstruMentDatas];
//    } withHight:192 withText:@"请修改设备信息" withDatas:nil];
//    alertDateView.modelTextField.text = self.subModel.C_NUMBER;
//    alertDateView.remarkText.placeholder = @"请输入位置";
//    alertDateView.remarkText.text = self.subModel.C_POSITION;
//
//    [self.view addSubview:alertDateView];
}

- (void)clickDeleteButton:(NSInteger)row {
	self.subModel = self.flowModel.content[row];
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确认删除设备信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alertView show];
}

- (void)liveButtonAction:(UIButton *)sender {
	NSInteger indexrow=sender.tag-3000;
	MJKFlowInstrumentSubModel *subModel =self.flowModel.content[indexrow];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_NAME"] = subModel.C_NAME;
	RecoLiveViw *liveView = [[RecoLiveViw alloc]initWithFrame:self.view.frame];
	[liveView initRecoLiveWithDic:dic];
	[[UIApplication sharedApplication].keyWindow addSubview:liveView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self HTTPDeleteFlowInstruMentDatas];
	}
}

#pragma mark - HTTP request
- (void)HTTPGetFlowInstruMentDatas {
	NSString *str;
	if ([self.title isEqualToString:@"人脸识别设置"]) {
		str = @"1";
	} else if ([self.title isEqualToString:@"WIFI设置"]) {
		str = @"0";
	} else {
		str = @"2";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getFlowSetList];
    [dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",(long)self.pages], @"pageSize" : [NSString stringWithFormat:@"%ld",(long)self.pagen], @"TYPE" : str} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.flowModel = [MJKFlowInstrumentModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPInsertFlowInstruMentDatas {
	NSString *str;
	if ([self.title isEqualToString:@"人脸识别设置"]) {
		str = @"1";
	} else if ([self.title isEqualToString:@"WIFI设置"]) {
		str = @"0";
	} else {
		str = @"2";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_insertFlowSet];
	[dict setObject:@{@"C_NUMBER" : self.subModel.C_NUMBER, @"C_POSITION" : self.subModel.C_POSITION,@"X_REMARK":self.subModel.X_REMARK, @"TYPE" : str} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
            [weakSelf.alertView removeFromSuperview];
			[weakSelf HTTPGetFlowInstruMentDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPChangeFlowInstruMentDatas {
	NSString *str;
	if ([self.title isEqualToString:@"人脸识别设置"]) {
		str = @"1";
	} else if ([self.title isEqualToString:@"WIFI设置"]) {
		str = @"0";
	} else {
		str = @"2";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updataFlowSet];
	[dict setObject:@{@"C_ID" : self.subModel.C_ID, @"C_NUMBER" : self.subModel.C_NUMBER, @"C_POSITION" : self.subModel.C_POSITION,@"X_REMARK":self.subModel.X_REMARK, @"TYPE" : str} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
            [weakSelf.alertView removeFromSuperview];
			[weakSelf HTTPGetFlowInstruMentDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPDeleteFlowInstruMentDatas {
	NSString *str;
	if ([self.title isEqualToString:@"人脸识别设置"]) {
		str = @"1";
	} else if ([self.title isEqualToString:@"WIFI设置"]) {
		str = @"0";
	} else {
		str = @"2";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_deleteFlowSet];
	[dict setObject:@{@"C_ID" : self.subModel.C_ID} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPGetFlowInstruMentDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.headView.frame.size.height, KScreenWidth, KScreenHeight - NavStatusHeight - self.headView.frame.size.height) style:UITableViewStyleGrouped];
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

@end
