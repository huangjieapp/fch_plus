//
//  CustomLabelHeaderView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CarSourceLabelHeaderView.h"
#import "MJKCarSourceSubModel.h"

#import "labelCustomButton.h"
#import "KSPhotoBrowser.h"
#import "CustomLabelModel.h"

@interface CarSourceLabelHeaderView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salerLabelCenterLayout;
@property (weak, nonatomic) IBOutlet UIButton *linkCustomerButton;
@property (weak, nonatomic) IBOutlet UIButton *customerButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageV;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;   //地址：
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSellerLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (assign, nonatomic) CGFloat height;



@end

@implementation CarSourceLabelHeaderView

-(void)awakeFromNib{
	[super awakeFromNib];
	
	UIView*BGView=[[UIView alloc]init];
	BGView.backgroundColor=[UIColor whiteColor];
	self.backgroundView=BGView;
	
	_mainImageV.layer.cornerRadius=6;
	_mainImageV.layer.masksToBounds=YES;
	_imageLabel.layer.cornerRadius=6;
	_imageLabel.layer.masksToBounds=YES;
	
	_mainImageV.userInteractionEnabled=YES;
	UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShowPhoto:)];
	[_mainImageV addGestureRecognizer:tap];
	
}


#pragma mark  --click
-(void)clickShowPhoto:(UITapGestureRecognizer*)tap{
	UIImageView*imageV=(UIImageView*)tap.view;
	UIImage*image=imageV.image;
	if (image) {
		MyLog(@"%@",image);
		KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageV image:image];
		KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
		[browser showFromViewController: [DBTools getSuperViewWithsubView:self]];
		
		
		
	}else{
		MyLog(@"没有图");
		
	}
	
	
	
}

-(IBAction)clickDetailButton{
	if (self.clickDetailBlock) {
		self.clickDetailBlock();
	}
	
	
}


-(void)clickToEditTagButton{
	if (!self.isZhanbai) {
		
		if (self.clickToEditTagViewBlock) {
			self.clickToEditTagViewBlock();
		}
		
		
	}
	
	
	
}



#pragma mark  --set
-(void)setType:(CarSourceInfo)Type{
	_Type=Type;
	if (self.Type==CarSourceInfoDetail) {
		UIButton*detailButton=[self viewWithTag:111];
		if (!detailButton) {
			detailButton= [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-30-20, 20, 16, 27)];
			//rightRow
			[detailButton setBackgroundImage:[UIImage imageNamed:@"右-潜客详情"] forState:UIControlStateNormal];
			detailButton.tag=111;
			[detailButton addTarget:self action:@selector(clickDetailButton)];
			//            [self addSubview:detailButton];
			
		}
		
		
		if (!self.isZhanbai) {
			detailButton.hidden=NO;
		}else{
			detailButton.hidden=YES;
		}
		
		
	}
	
	
	
}

- (IBAction)linkCustomerAction:(UIButton *)sender {
    if (self.clickLinkCustomerBlock) {
        self.clickLinkCustomerBlock();
    }
}



-(void)setMainModel:(MJKCarSourceSubModel *)mainModel{
	_mainModel=mainModel;
	NSString*name=mainModel.C_NAME;;
	if (name.length>=1) {
		self.imageLabel.text=[name substringToIndex:1];
	}
	
	
	if (!mainModel.X_PICTURE||[mainModel.X_PICTURE isEqualToString:@""]) {
		self.imageLabel.hidden=NO;
		self.mainImageV.backgroundColor=DBColor(229, 229, 229);
		self.mainImageV.image=nil;
		
	}else{
		self.imageLabel.hidden=YES;
		self.mainImageV.backgroundColor=[UIColor clearColor];
		[self.mainImageV sd_setImageWithURL:[NSURL URLWithString:mainModel.X_PICTURE] placeholderImage:[UIImage imageNamed:@"placeholder"]];
		
	}
	NSString *str = mainModel.C_OWNER_ROLENAME;
	
	self.rightSellerLab.text=str;
	
	
	if ([mainModel.C_SEX_DD_NAME isEqualToString:@"男"]) {
		self.sexLabel.image=[UIImage imageNamed:@"iv_man"];
	}else if ([mainModel.C_SEX_DD_NAME isEqualToString:@"女"]){
		self.sexLabel.image=[UIImage imageNamed:@"iv_women"];
	}
	
	else{
		self.sexLabel.image=[UIImage imageNamed:nil];
	}
	
	
	self.nameLabel.text=name;
	//	self.phoneLabel.text = mainModel.C_PHONE;
	
	
	NSString*levelStr=mainModel.C_LEVEL_DD_NAME;
	if (levelStr&&![levelStr isEqualToString:@""]) {
		NSString*first=[levelStr substringToIndex:1];
		self.levelImageV.image=[UIImage imageNamed:first];
	}else{
		self.levelImageV.image=nil;
	}
	
    self.remarkLabel.text = mainModel.C_PHONE;
    self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@",mainModel.D_CREATE_TIME,mainModel.C_TYPE_DD_NAME, mainModel.C_STATUS_DD_NAME,mainModel.C_CPSZD_DD_NAME, mainModel.C_CPH];
}

@end
