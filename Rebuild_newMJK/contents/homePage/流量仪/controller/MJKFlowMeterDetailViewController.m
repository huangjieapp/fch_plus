//
//  MJKFlowMeterDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterDetailViewController.h"
#import "MJKFlowMeterConductViewController.h"

#import "MJKFlowMeterDetailModel.h"

#import "MJKFlowMeterDetailTableViewCell.h"
#import "KSPhotoBrowser.h"

#import "NSString+Extern.h"


#import "CustomerDetailViewController.h"

@interface MJKFlowMeterDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MJKFlowMeterDetailModel *detailModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
/** 是否本次接待*/
@property (nonatomic, assign) BOOL isThisArrival;
@end

@implementation MJKFlowMeterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	if ([self.VCName isEqualToString:@"处理"]) {
		self.title = @"流量信息";
	} else {
		self.title = @"流量仪详情";
	}
	self.isThisArrival = NO;
    [self HTTPGetFlowMeterDetailDatas];
	self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.tableView];
	if ([self.model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
		[self createButton];
	}
	
}

- (void)showHeadImage {
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 5;
	} else {
		return 4;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowMeterDetailTableViewCell *cell = [MJKFlowMeterDetailTableViewCell cellWithTableView:tableView];
	[cell updataCellWithTitleArray:@[@[@"位        置",@"到店时间", @"到店次数", @"年        龄", @"性        别"], self.isThisArrival == NO > 0 ? @[@"上次接待员工", @"上次处理时间", @"处理结果", @"关联客户"] : @[@"本次接待员工", @"本次处理时间", @"处理结果", @"关联客户"]] andContent:@[[self showFirstSectionArray:self.detailModel], [self showSecondSectionArray:self.detailModel]] andIndexPath:indexPath];
	DBSelf(weakSelf);
	if (indexPath.section == 0) {
		if (indexPath.row == [self showFirstSectionArray:self.detailModel].count - 1) {
			cell.sepLabel.hidden = NO;
		}
	} else {
		if (indexPath.row == [self showSecondSectionArray:self.detailModel].count - 1) {
			cell.sepLabel.hidden = NO;
			if (self.detailModel.C_A41500_C_NAME.length > 0) {
				cell.toCustomerImageView.hidden = NO;
				cell.toCustomerBlock = ^{
					CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
					vc.popVC=weakSelf.flowMachineListVC;
					PotentailCustomerListDetailModel*mainModel=[[PotentailCustomerListDetailModel alloc]init];
					mainModel.C_A41500_C_ID=self.detailModel.C_A41500_C_ID;
					vc.mainModel=mainModel;
					//客户详情里输入框下面弹框内容，如果是协助就只有新增预约
					[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
					[weakSelf.navigationController pushViewController:vc animated:YES];

				};
			}
			cell.contentLeftLayout.constant = 40;
		}
	}
	return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
	view.backgroundColor = DBColor(236, 237,241);
	UILabel *label = [[UILabel alloc]init];
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:12.0f];
	if (section == 0) {
		label.frame = CGRectMake(20, 70, 100, 20);
		label.text = @"流量信息";
		UIView *imageV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
		imageV.backgroundColor = [UIColor whiteColor];
		[view addSubview:imageV];
		UIImageView *imageView = [[UIImageView alloc]init];
		[imageV addSubview:imageView];
		imageView.layer.cornerRadius = 5.0f;
		imageView.layer.masksToBounds = YES;
		imageView.frame = CGRectMake((imageV.frame.size.width - 50) / 2, (imageV.frame.size.height - 65) / 2, 50, 65);
								
		if (self.detailModel.C_HEADPIC.length > 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.C_HEADPIC]];
//            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailModel.C_HEADPIC]]];
		}
        
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageV:)];
        [imageView addGestureRecognizer:tap];
        
       
        
        
		
	} else {
		label.frame = CGRectMake(20, 0, 100, 20);
		label.text = @"处理信息";
	}
	[view addSubview:label];
	return view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//	UIView *view = [[UIView alloc]initWithFrame:self.tableView.tableFooterView.frame];
//	view.backgroundColor = DBColor(236, 237,241);
//	return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 90;
	} else {
		return 20;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//	if (section == 0) {
		return .1;
//	} else {
//		return 100;
//	}
}

- (void)createButton {
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 580, KScreenWidth, 90)];
	[self.scrollView addSubview:view];
	
//	self.scrollView.contentSize = CGSizeMake(KScreenWidth, self.tableView.frame.size.height + 90);
	UIButton *clueButton = [[UIButton alloc]initWithFrame:CGRectMake(20, (view.frame.size.height - 80) / 2, KScreenWidth - 40, 35)];
	[clueButton setTitle:@"流量处理" forState:UIControlStateNormal];
	[clueButton setBackgroundColor:DBColor(255,195,0)];
	[clueButton setTitleColor:DBColor(255, 255, 255) forState:UIControlStateNormal];
	[clueButton addTarget:self action:@selector(clueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:clueButton];
	UIButton *staffButton = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(clueButton.frame) + 5, (KScreenWidth - 40 - 10) / 3, 35)];
	[staffButton setTitle:@"员工" forState:UIControlStateNormal];
	[staffButton setBackgroundColor:DBColor(233,234,239)];
	[staffButton setTitleColor:DBColor(51, 51, 51) forState:UIControlStateNormal];
	[staffButton addTarget:self action:@selector(staffButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:staffButton];
	UIButton *wxButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staffButton.frame) + 5, CGRectGetMaxY(clueButton.frame) + 5, (KScreenWidth - 40 - 10) / 3, 35)];
	[wxButton setTitle:@"无效" forState:UIControlStateNormal];
	[wxButton setBackgroundColor:DBColor(233,234,239)];
	[wxButton setTitleColor:DBColor(51, 51, 51) forState:UIControlStateNormal];
	[wxButton addTarget:self action:@selector(wxButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:wxButton];
	UIButton *hmdButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wxButton.frame) + 5, CGRectGetMaxY(clueButton.frame) + 5, (KScreenWidth - 40 - 10) / 3, 35)];
	[hmdButton setTitle:@"黑名单" forState:UIControlStateNormal];
	[hmdButton setBackgroundColor:DBColor(233,234,239)];
	[hmdButton setTitleColor:DBColor(51, 51, 51) forState:UIControlStateNormal];
	[hmdButton addTarget:self action:@selector(hmdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:hmdButton];
	clueButton.titleLabel.font =
	staffButton.titleLabel.font =
	wxButton.titleLabel.font =
	hmdButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	clueButton.layer.cornerRadius =
	staffButton.layer.cornerRadius =
	wxButton.layer.cornerRadius =
	hmdButton.layer.cornerRadius = 3.0f;
	
	NSString *type = [NSString iphoneType];
	if (!([type isEqualToString:@"iPhone 5"] || [type isEqualToString:@"iPhone 5c"] || [type isEqualToString:@"iPhone 5s"] || [type isEqualToString:@"iPhone Simulator"])) {
		self.scrollView.contentSize = CGSizeMake(KScreenWidth, 580 + 150);
		staffButton.frame = CGRectMake(20, CGRectGetMaxY(clueButton.frame) + 10, (KScreenWidth - 40 - 20) / 3, 35);
		wxButton.frame = CGRectMake(CGRectGetMaxX(staffButton.frame) + 10, CGRectGetMaxY(clueButton.frame) + 10, (KScreenWidth - 40 - 20) / 3, 35);
		hmdButton.frame = CGRectMake(CGRectGetMaxX(wxButton.frame) + 10, CGRectGetMaxY(clueButton.frame) + 10, (KScreenWidth - 40 - 20) / 3, 35);
	} else {
		self.scrollView.contentSize = CGSizeMake(KScreenWidth, self.tableView.frame.size.height + 150);
	}
}

#pragma mark - 点击事件
-(void)scaleImageV:(UITapGestureRecognizer*)tap{
    UIImageView*imageV=(UIImageView*)tap.view;
    if (imageV.image) {
        //放大图片
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageV image:imageV.image];
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
        [browser showFromViewController:self];

    }
   
    
}


- (void)HTTPInsertFlowDatas:(NSString *)userid complete:(void(^)(id data))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_flowInsert];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"I_PEPOLE_NUMBER" : @"1", @"D_ARRIVAL_TIME" : self.detailModel.D_ARRIVAL_TIME, @"USER_ID" :userid, @"C_CLUESOURCE_DD_ID" :@"", @"C_A41200_C_ID" : @"", @"X_REMARK" : @""}];
    [contentDict setObject:[DBObjectTools flowAboutC_id] forKey:@"C_ID"];
    [contentDict setObject:self.detailModel.C_ID forKey:@"C_A46000_C_ID"];
    
    [dict setObject:contentDict forKey:@"content"];
//    [dict setObject:@{@"C_ID" :  self.detailModel.C_ID, } forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
//        "C_ID" = "A46000-1604903D22EDVRS8DQKGM47G201QRY968";
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            successBlock(data);
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}


//关联客户      关联是2
- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:@{@"C_ID" : C_ID, @"TYPE" : @"2", @"C_A41500_C_ID" : C_A41500_C_ID} compliation:^(id data, NSError *error) {
        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
           //是不是  有潜客id  然后跳到潜客页面
//            CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
//            vc.popVC=weakSelf.flowMachineListVC;
//            PotentailCustomerListDetailModel*mainModel=[[PotentailCustomerListDetailModel alloc]init];
//            mainModel.C_A41500_C_ID=C_A41500_C_ID;
//            vc.mainModel=mainModel;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
			MJKFlowMeterConductViewController *vc = [[MJKFlowMeterConductViewController alloc]init];
			vc.flowMeterModel = self.detailModel;
			vc.isVip = @"yes";
			vc.headImageArray = [NSArray arrayWithObject:self.detailModel.C_HEADPIC];
			[self.navigationController pushViewController:vc animated:YES];
			
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}



//线索处理
- (void)clueButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
    if (self.detailModel.C_A41500_C_NAME.length>0){
        NSString*message=[NSString stringWithFormat:@"是否关联流量到识别客户%@",self.detailModel.C_A41500_C_NAME];
        
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //流量仪处理界面
            MJKFlowMeterConductViewController *vc = [[MJKFlowMeterConductViewController alloc]init];
            vc.popVC=weakSelf.flowMachineListVC;
			vc.rootViewController = self.rootVC;
            vc.flowMeterModel = weakSelf.detailModel;
            vc.headImageArray = [NSArray arrayWithObject:weakSelf.detailModel.C_HEADPIC];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        }];
        UIAlertAction*sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //先新增流量    再关联潜客
//            [self HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
//                MyLog(@"%@",data);
//                //留的
//                NSString*currentID=data[@"C_ID"];
//                [self HTTPCustomConnect:currentID andType:@"2" andC_A41500_C_ID:self.detailModel.C_A41500_C_ID];
//
//
//
//            }];
			MJKFlowMeterConductViewController *vc = [[MJKFlowMeterConductViewController alloc]init];
			vc.flowMeterModel = weakSelf.detailModel;
			vc.isVip = @"yes";
			vc.headImageArray = [NSArray arrayWithObject:weakSelf.detailModel.C_HEADPIC];
			[weakSelf.navigationController pushViewController:vc animated:YES];
			
            
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }else{

    
    
    
	MJKFlowMeterConductViewController *vc = [[MJKFlowMeterConductViewController alloc]init];
	vc.flowMeterModel = self.detailModel;
		if (self.detailModel.C_HEADPIC.length > 0) {
			vc.headImageArray = [NSArray arrayWithObject:self.detailModel.C_HEADPIC];
		}
	vc.rootViewController = self.rootVC;
	[self.navigationController pushViewController:vc animated:YES];
        
    }
}


-(void)showAlertWithStr:(NSString*)showStr{
    NSString*messageStr;
    if ([showStr isEqualToString:@"员工"]) {
        messageStr=@"是否将此流量转为员工";
        
    }else if ([showStr isEqualToString:@"无效"]){
        messageStr=@"是否将此流量转为无效";
    }else if ([showStr isEqualToString:@"黑名单"]){
        messageStr=@"是否将此流量转为黑名单";
        
    }
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([showStr isEqualToString:@"员工"]) {
            [self HTTPUpdataFlowMeterData:@"1"];
            
        }else if ([showStr isEqualToString:@"无效"]){
           [self HTTPUpdataFlowMeterData:@"0"];
        }else if ([showStr isEqualToString:@"黑名单"]){
            [self HTTPUpdataFlowMeterData:@"2"];
            
        }
        
        
    }];
    UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}


// 员工
- (void)staffButtonAction:(UIButton *)sender {
	if (![[NewUserSession instance].appcode containsObject:@"APP010_0008"]) {
		[JRToast showWithText:@"账号无权限"];
		return;
	}
    [self showAlertWithStr:@"员工"];
    
	
}

//无效
- (void)wxButtonAction:(UIButton *)sender {
	if (![[NewUserSession instance].appcode containsObject:@"APP010_0009"]) {
		[JRToast showWithText:@"账号无权限"];
		return;
	}
    [self showAlertWithStr:@"无效"];
}

//黑名单
- (void)hmdButtonAction:(UIButton *)sender {
	
//    if (![[NewUserSession instance].appcode containsObject:@"APP010_0010"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
	[self showAlertWithStr:@"黑名单"];
}


#pragma mark - HTTP request
- (void)HTTPGetFlowMeterDetailDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_GetFlowMeterDetail];
	[dict setObject:@{@"C_ID" : self.model.C_ID} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKFlowMeterDetailModel yy_modelWithDictionary:data];
			
			if (![weakSelf.detailModel.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
				weakSelf.isThisArrival = YES;
//				weakSelf.detailModel.C_SALEID = [NewUserSession instance].user.u051Id;
//				weakSelf.detailModel.C_SALENAME = [NewUserSession instance].user.nickName;
//				weakSelf.detailModel.D_BEFORE_TIME = [DBTools getYearMonthDayTime];
			}
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPUpdataFlowMeterData:(NSString *)type {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_UpdataFlowMeter];
	[dict setObject:@{@"C_ID" : self.model.C_ID, @"ARRIVAL_TYPE" : type} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (NSMutableArray *)showFirstSectionArray:(MJKFlowMeterDetailModel *)model {
	NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:model.C_POSITION.length > 0 ? model.C_POSITION : @""];
	[arr addObject:model.D_ARRIVAL_TIME.length > 0 ? model.D_ARRIVAL_TIME : @""];
//	[arr addObject:model.C_ARRIVAL_DD_NAME.length > 0 ? model.C_ARRIVAL_DD_NAME : @""];
	[arr addObject:model.I_ARRIVAL.length > 0 ? model.I_ARRIVAL : @""];
	[arr addObject:model.C_AGE.length > 0 ? model.C_AGE : @""];
	[arr addObject:model.C_SEX.length > 0 ? model.C_SEX : @""];
	return arr;
}

- (NSMutableArray *)showSecondSectionArray:(MJKFlowMeterDetailModel *)model {
	
	NSMutableArray *arr = [NSMutableArray array];
	//有本次接待
	if (model.USERID.length > 0) {
		[arr addObject:model.USERNAME];
		if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
			[arr addObject:model.D_BEFORE_TIME.length > 0 ? model.D_BEFORE_TIME : @""];
		} else {
			[arr addObject:model.D_OPERATION_TIME];
		}
	
//	[arr addObject:model.C_RESULT_DD_NAME.length > 0 ? model.C_RESULT_DD_NAME : @""];
//	[arr addObject:model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @""];
	} else {//处理以前流量
		if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
			[arr addObject:model.C_SALENAME.length > 0 ? model.C_SALENAME : @""];
			[arr addObject:model.D_BEFORE_TIME.length > 0 ? model.D_BEFORE_TIME : @""];
		} else {
			[arr addObject:model.C_SALENAME.length > 0 ? model.C_SALENAME : @""];
			[arr addObject:model.D_OPERATION_TIME.length > 0 ? model.D_OPERATION_TIME : @""];
		}
		
	}
	[arr addObject:model.C_RESULT_DD_NAME.length > 0 ? model.C_RESULT_DD_NAME : @""];
	[arr addObject:model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @""];
	return arr;
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.bounces = NO;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}




@end
