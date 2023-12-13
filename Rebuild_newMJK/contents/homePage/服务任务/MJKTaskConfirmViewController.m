//
//  MJKTaskConfirmViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/12.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTaskConfirmViewController.h"
#import "ServiceTaskViewController.h"
#import "CustomerDetailViewController.h"
#import "ServiceTaskDetailModel.h"

#import "OrderDetailViewController.h"
#import "MJKMessagePushNotiViewController.h"

#import "DBPickerView.h"

@interface MJKTaskConfirmViewController ()
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *levelTF;
/** 数据dic*/
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation MJKTaskConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
	self.title = @"确认任务";
    self.startTimeTF.inputView = self.endTimeTF.inputView = self.levelTF.inputView = [[UIView alloc]init];
	
	if (self.mainDatasModel != nil) {
		
		if (self.mainDatasModel.D_CONFIRMED_TIME.length == 19) {
			self.dict[@"startTime"] = self.mainDatasModel.D_CONFIRMED_TIME;
			self.startTimeTF.text = [self.mainDatasModel.D_CONFIRMED_TIME stringByAppendingString:@">"];
		} else {
			if (self.mainDatasModel.D_CONFIRMED_TIME.length > 0) {
				self.dict[@"startTime"] = [self.mainDatasModel.D_CONFIRMED_TIME stringByAppendingString:@":00"];
				self.startTimeTF.text = [self.mainDatasModel.D_CONFIRMED_TIME stringByAppendingString:@":00>"];
			}
			
		}
		
		if (self.mainDatasModel.D_ORDER_TIME.length == 19) {
			self.dict[@"finishTime"] = self.mainDatasModel.D_ORDER_TIME;
			self.endTimeTF.text = [self.mainDatasModel.D_ORDER_TIME stringByAppendingString:@">"];
		} else {
			if (self.mainDatasModel.D_ORDER_TIME.length > 0) {
				self.dict[@"finishTime"] = [self.mainDatasModel.D_ORDER_TIME stringByAppendingString:@":00"];
				self.endTimeTF.text = [self.mainDatasModel.D_ORDER_TIME stringByAppendingString:@":00>"];
			}
			
		}
		
		
//		self.endTimeTF.text = [self.mainDatasModel.D_ORDER_TIME stringByAppendingString:@">"];
//		self.dict[@"finishTime"] = self.mainDatasModel.D_ORDER_TIME;
		self.levelTF.text = [NSString stringWithFormat:@"%@>",self.mainDatasModel.C_TASKSTATUS_DD_NAME];
		self.dict[@"level"] = self.mainDatasModel.C_TASKSTATUS_DD_ID;
	} else {
		self.levelTF.text = @"高>";
		self.dict[@"level"] = @"A01200_C_TASKSTATUS_0000";
	}
	
}
- (IBAction)timeClick:(UITextField *)sender {
	DBSelf(weakSelf);
    DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeDate andmtArrayDatas:nil  andSelectStr:sender == self.startTimeTF ? weakSelf.dict[@"startTime"] : weakSelf.dict[@"finishTime"] andTitleStr:sender == self.startTimeTF ? @"计划开始时间" : @"计划完成时间" andBlock:^(NSString *title, NSString *indexStr) {
		MyLog(@"%@    %@",title,indexStr);
		if (sender == self.startTimeTF) {
			weakSelf.startTimeTF.text = [title stringByAppendingString:@">"];
			weakSelf.dict[@"startTime"] = title;
		} else {
			weakSelf.endTimeTF.text = [title stringByAppendingString:@">"];
			weakSelf.dict[@"finishTime"] = title;
		}
		
	}];
	
	pickerV.cancelBlock = ^{
		[weakSelf.startTimeTF resignFirstResponder];
		[weakSelf.endTimeTF resignFirstResponder];
		[weakSelf.levelTF resignFirstResponder];
	};
	
	[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
}
- (IBAction)levelClick:(UITextField *)sender {
	DBSelf(weakSelf);
	NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TASKSTATUS"];
	NSMutableArray*mtArray=[NSMutableArray array];
	
	NSMutableArray*postArray=[NSMutableArray array];
	for (MJKDataDicModel*model in dataArray) {
		[mtArray addObject:model.C_NAME];
		[postArray addObject:model.C_VOUCHERID];
	}
	DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray  andSelectStr:nil andTitleStr:@"优先等级" andBlock:^(NSString *title, NSString *indexStr) {
		MyLog(@"%@    %@",title,indexStr);
		weakSelf.levelTF.text = [title stringByAppendingString:@">"];
		NSInteger number=[indexStr integerValue];
		NSString *postStr = postArray[number];
		weakSelf.dict[@"level"] = postStr;
		
	}];
	pickerV.cancelBlock = ^{
		[weakSelf.startTimeTF resignFirstResponder];
		[weakSelf.endTimeTF resignFirstResponder];
		[weakSelf.levelTF resignFirstResponder];
	};
	[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
}

- (void)backFrontVC {
    if ([self.vcName isEqualToString:@"客户"]) {//CustomerDetailViewController
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }  else if ([self.vcName isEqualToString:@"订单"]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
    
}
//提交
- (IBAction)submitButtonAction:(id)sender {
	DBSelf(weakSelf);
	if ([self.dict[@"startTime"] length] <= 0) {
		[JRToast showWithText:@"请选择计划开始时间"];
		return;
	}
	if ([self.dict[@"finishTime"] length] <= 0) {
		[JRToast showWithText:@"请选择计划结束时间"];
		return;
	}
	if ([self.dict[@"level"] length] <= 0) {
		[JRToast showWithText:@"请选择预优先等级"];
		return;
	}
	[self HttpPostChangeServiceSuccess:^(id data) {
		
        
            if ([weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0005"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0003"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0000"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0001"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0012"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0016"]) {
                NSString *RWTSDW;
                if ([weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0001"]) {
                    if (![[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0004"]) {
                        [weakSelf backFrontVC];
                        return ;
                    }
                    RWTSDW = @"A47500_C_RWTSDW_0004";
                } else if ([weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0012"]) {
                    if (![[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0012"]) {
                        [weakSelf backFrontVC];
                        return ;
                    }
                     RWTSDW = @"A47500_C_RWTSDW_0003";
                } else if ([weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0005"]) {
                    if (![[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0006"]) {
                        [weakSelf backFrontVC];
                        return ;
                    }
                    RWTSDW = @"A47500_C_RWTSDW_0006";
                } else if ([weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0016"] || [weakSelf.mainDatasModel.C_TYPE_DD_ID isEqualToString:@"A01200_C_TYPE_0000"]) {
                    if (![[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0005"]) {
                        [weakSelf backFrontVC];
                        return ;
                    }
                    RWTSDW = @"A47500_C_RWTSDW_0005";
                } else {
                    if (![[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_RWTSDW_0000"]) {
                        [weakSelf backFrontVC];
                        return ;
                    }
                    RWTSDW = @"A47500_C_RWTSDW_0000";
                }
                [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.mainDatasModel.C_A41500_C_ID andC_ID:weakSelf.mainDatasModel.C_ID andC_TYPE_DD_ID:RWTSDW andVC:self andYesBlock:^(NSDictionary * _Nonnull data) {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    vc.dataDic = data[@"content"];
                    vc.C_A41500_C_ID = weakSelf.mainDatasModel.C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = RWTSDW;
                    vc.C_ID = weakSelf.mainDatasModel.C_ID;
                    vc.titleNameXCX = [NSString stringWithFormat:@"%@服务通知",self.mainDatasModel.C_TYPE_DD_NAME];
                    vc.backActionBlock = ^{
                        if ([weakSelf.vcName isEqualToString:@"客户"]) {//CustomerDetailViewController
                            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }  else if ([weakSelf.vcName isEqualToString:@"订单"]) {
                            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }
                        else {
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                            }
                        }
                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } andNoBlock:^{
                    if ([weakSelf.vcName isEqualToString:@"客户"]) {//CustomerDetailViewController
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }  else if ([weakSelf.vcName isEqualToString:@"订单"]) {
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }
                    else {
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    }
                }];

            } else {
                if ([weakSelf.vcName isEqualToString:@"客户"]) {//CustomerDetailViewController
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }  else if ([weakSelf.vcName isEqualToString:@"订单"]) {
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }
                else {
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ServiceTaskViewController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                    }
                }
                }
            }
            
            
        
			
//			else {
//				[vc removeFromParentViewController];
//			}
		
	}];
}

#pragma mark updateOperation
-(void)HttpPostChangeServiceSuccess:(void(^)(id data))successBlock{
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_operationServiceTask];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:@"1" forKey:@"STATUS_TYPE"];
	[contentDict setObject:self.taskID forKey:@"C_ID"];
	if (self.dict != nil) {
		[contentDict setObject:self.dict[@"startTime"] forKey:@"D_START_TIME"];
		[contentDict setObject:self.dict[@"finishTime"] forKey:@"D_END_TIME"];
		[contentDict setObject:self.dict[@"level"] forKey:@"C_TASKSTATUS_DD_ID"];
	}
		
	
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			successBlock(data);
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

- (NSMutableDictionary *)dict {
	if (!_dict) {
		_dict = [NSMutableDictionary dictionary];
	}
	return _dict;
}

@end
