//
//  SHChatInterfaceView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHChatInterfaceView.h"
#import "AddOrEditlCustomerViewController.h"//新增客户

@implementation SHChatInterfaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.NewCustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(110);
		//间距三等分(屏幕适配)
		make.left.mas_equalTo((KScreenWidth - 110 - 110) / 3);
		make.height.mas_equalTo(18);
		make.bottom.mas_equalTo(-6);
	}];
	[self.AssCustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(110);
		make.right.mas_equalTo(-((KScreenWidth - 110 - 110) / 3));
		make.height.mas_equalTo(18);
		make.bottom.mas_equalTo(-6);
	}];
	self.NewCustBtn.layer.cornerRadius = self.AssCustBtn.layer.cornerRadius = 5.0f;
}


+(instancetype)chatInterfaceView{
    SHChatInterfaceView*chatView=[[NSBundle mainBundle]loadNibNamed:@"SHChatInterfaceView" owner:nil options:nil].firstObject;
    chatView.frame=CGRectMake(0, 0, KScreenWidth, 175);
    
    return chatView;
    
}
//新增客户
- (IBAction)addNewCust:(UIButton *)sender {	AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
	vc.Type = customerTypeAdd;
	vc.superVC = self.rootVC;
	vc.pubNameStr = self.wechatListSubModel.C_NAME;
	vc.pubTelStr = self.wechatListSubModel.C_PHONE;
	vc.pubRemarketStr = self.wechatListSubModel.X_REMARK;
	[self.rootVC.navigationController pushViewController:vc animated:YES];
}
//关联客户
- (IBAction)assCust:(UIButton *)sender {
    MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
	DBSelf(weakSelf);
	customListVC.rootVC = [DBTools getSuperViewWithsubView:self];
//	customListVC.textFieldText = self.wechatListSubModel.C_PHONE;
	customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
//		[weakSelf HTTPCustomConnect:@"" andType:@"2" andC_A41500_C_ID:model.C_A41500_C_ID];
	};
	[self.rootVC.navigationController pushViewController:customListVC animated:YES];
}

//关联客户
- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:@{@"C_ID" : C_ID, @"TYPE" : type, @"C_A41500_C_ID" : C_A41500_C_ID} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
//			if (complete) {
//				complete();
//			}
			[weakSelf.rootVC.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}


@end
