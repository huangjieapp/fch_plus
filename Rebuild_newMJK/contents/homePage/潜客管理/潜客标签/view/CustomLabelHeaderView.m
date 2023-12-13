//
//  CustomLabelHeaderView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CustomLabelHeaderView.h"
#import "labelCustomButton.h"
#import "KSPhotoBrowser.h"
#import "CustomLabelModel.h"

@interface CustomLabelHeaderView()
//还是要先移除所有的button
@property(nonatomic,strong)NSMutableArray*saveAllLabelArray;

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

@implementation CustomLabelHeaderView

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
-(void)setType:(CusomterInfo)Type{
	_Type=Type;
	if (self.Type==CusomterInfoDetail) {
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

- (void)setMembersDetailModel:(CustomerDetailInfoModel *)membersDetailModel {
    _membersDetailModel=membersDetailModel;
    self.customerButton.hidden = YES;
    if (membersDetailModel.C_A41500_C_ID.length > 0) {
        self.linkCustomerButton.hidden = NO;
    } else {
        self.linkCustomerButton.hidden = YES;
    }
    NSString*name=[NSString stringWithFormat:@"%@   %@",membersDetailModel.C_NAME,membersDetailModel.C_LEVEL_DD_NAME] ;
    if (name.length>=1) {
        self.imageLabel.text=[name substringToIndex:1];
    }
    
    
    if (!membersDetailModel.C_HEADIMGURL||[membersDetailModel.C_HEADIMGURL isEqualToString:@""]) {
        self.imageLabel.hidden=NO;
        self.mainImageV.backgroundColor=DBColor(229, 229, 229);
        self.mainImageV.image=nil;
        
    }else{
        self.imageLabel.hidden=YES;
        self.mainImageV.backgroundColor=[UIColor clearColor];
        [self.mainImageV sd_setImageWithURL:[NSURL URLWithString:membersDetailModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",membersDetailModel.C_OWNER_ROLENAME];
    self.rightSellerLab.text=str;
    self.salerLabelCenterLayout.constant = 0;
//    if ([self.nameType isEqualToString:@"粉丝"]) {
//        self.rightSellerLab.text = membersDetailModel.C_NAME;
//    }
    
    if ([membersDetailModel.C_SEX_DD_NAME isEqualToString:@"男"]) {
        self.sexLabel.image=[UIImage imageNamed:@"iv_man"];
    }else if ([membersDetailModel.C_SEX_DD_NAME isEqualToString:@"女"]){
        self.sexLabel.image=[UIImage imageNamed:@"iv_women"];
    }
    
    else{
        self.sexLabel.image=[UIImage imageNamed:nil];
    }
    
    
    self.nameLabel.text=name;
    //    self.phoneLabel.text = mainModel.C_PHONE;
    
    self.levelImageV.hidden = YES;
    NSString*levelStr=membersDetailModel.C_LEVEL_DD_NAME;
    if (levelStr&&![levelStr isEqualToString:@""]) {
        NSString*first=[levelStr substringToIndex:1];
        self.levelImageV.image=[UIImage imageNamed:first];
    }else{
        self.levelImageV.image=nil;
    }
    
    
    
    
    
    NSString*C_STAR_DD_ID=membersDetailModel.C_STAR_DD_ID;
    if ([C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {//星标未选中
        self.starImageV.image=[UIImage imageNamed:@"星标"];
    }else//星标选中
    {
        self.starImageV.image=[UIImage imageNamed:@"未星标"];
    }
//    self.starImageV.hidden = YES;
    
    CGRect frame = self.remarkLabel.frame;
    NSString *phoneStr = @"";
    if (membersDetailModel.C_PHONE.length > 0) {
        if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
            phoneStr = membersDetailModel.C_PHONE;
        } else {
            phoneStr = [membersDetailModel.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
        }
        
    }
    self.remarkLabel.text = [NSString stringWithFormat:@"%@  %@",phoneStr,membersDetailModel.C_ENGLISHNAME.length > 0 ? membersDetailModel.C_ENGLISHNAME : @""];
    
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
    CGSize size = [self.remarkLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    frame.size.height = size.height;
    self.remarkLabel.frame = frame;
    //    self.remarkLabel.text=[NSString stringWithFormat:@"地址:%@",mainModel.C_ADDRESS];
    
    
    self.bottomLabel.text=[NSString stringWithFormat:@"%@ %@",membersDetailModel.D_CREATE_TIME,membersDetailModel.C_TYPE_DD_NAME.length > 0 ? membersDetailModel.C_TYPE_DD_NAME : @""];
    if (self.returnHeightBlock) {
        CGFloat height =size.height + 30 + 80;
        self.returnHeightBlock(height);
    }
    self.height = size.height;
}
- (IBAction)linkCustomerAction:(UIButton *)sender {
    if (self.clickLinkCustomerBlock) {
        self.clickLinkCustomerBlock();
    }
}



-(void)setMainModel:(CustomerDetailInfoModel *)mainModel{
	_mainModel=mainModel;
	NSString*name=mainModel.C_NAME;
	if (name.length>=1) {
		self.imageLabel.text=[name substringToIndex:1];
	}
	
	
	if (!mainModel.C_HEADIMGURL||[mainModel.C_HEADIMGURL isEqualToString:@""]) {
		self.imageLabel.hidden=NO;
		self.mainImageV.backgroundColor=DBColor(229, 229, 229);
		self.mainImageV.image=nil;
		
	}else{
		self.imageLabel.hidden=YES;
		self.mainImageV.backgroundColor=[UIColor clearColor];
		[self.mainImageV sd_setImageWithURL:[NSURL URLWithString:mainModel.C_HEADIMGURL_SHOW] placeholderImage:[UIImage imageNamed:@"placeholder"]];
		
	}
	NSString *str;
	if (mainModel.C_DESIGNER_ROLENAME.length > 0) {
		str = [NSString stringWithFormat:@"%@/%@",mainModel.C_OWNER_ROLENAME,mainModel.C_DESIGNER_ROLENAME];
	} else {
		str = mainModel.C_OWNER_ROLENAME;
	}
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
	
	
	
	
	
	NSString*C_STAR_DD_ID=mainModel.C_STAR_DD_ID;
	if ([C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0001"]) {//星标未选中
		self.starImageV.image=[UIImage imageNamed:@"未星标"];
		
	}else//星标选中
	{
		self.starImageV.image=[UIImage imageNamed:@"星标"];
		
		
	}
	
	CGRect frame = self.remarkLabel.frame;
	NSString *phoneStr = @"";
	if (mainModel.C_PHONE.length > 0) {
		if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
			phoneStr =  [NSString stringWithFormat:@"%@ %@",mainModel.C_PHONE, mainModel.D_CREATE_TIME];
		} else {
			phoneStr = [NSString stringWithFormat:@"%@ %@",[mainModel.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"], mainModel.D_CREATE_TIME];
		}
		
	}
    
//    if (mainModel.C_A48200_C_NAME.length > 0) {
//        self.remarkLabel.text = [NSString stringWithFormat:@"%@ %@  %@",phoneStr,mainModel.C_A48200_C_NAME,mainModel.C_ADDRESS.length > 0 ? mainModel.C_ADDRESS : @""];
        self.remarkLabel.text =phoneStr;
//    } else {
//        self.remarkLabel.text = [NSString stringWithFormat:@"%@  %@",phoneStr,mainModel.C_ADDRESS.length > 0 ? mainModel.C_ADDRESS : @""];
//        self.remarkLabel.text = mainModel.C_A49600_C_NAME;
//    }
	
	
	
	NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
	CGSize size = [self.remarkLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
	frame.size.height = size.height;
	self.remarkLabel.frame = frame;
	//    self.remarkLabel.text=[NSString stringWithFormat:@"地址:%@",mainModel.C_ADDRESS];
	
	
//	self.bottomLabel.text=[NSString stringWithFormat:@"%@ %@ %@",mainModel.D_CREATE_TIME,mainModel.C_STAGE_DD_NAME.length > 0 ? mainModel.C_STAGE_DD_NAME : @"",mainModel.C_CLUESOURCE_DD_NAME.length > 0 ? mainModel.C_CLUESOURCE_DD_NAME : @""];
    self.bottomLabel.text=[NSString stringWithFormat:@"%@ %@ %@", mainModel.C_A49600_C_NAME, (mainModel.C_STAGE_DD_NAME ?: @""), mainModel.C_CLUESOURCE_DD_NAME];
	if (self.returnHeightBlock) {
		CGFloat height =size.height + 30 + 80;
		self.returnHeightBlock(height);
	}
	self.height = size.height;
}








-(void)setAllLabelArray:(NSMutableArray *)allLabelArray{
	_allLabelArray=allLabelArray;
	
	UIButton*NoneButton=[self viewWithTag:917];
	[NoneButton removeFromSuperview];
	
	
	//先移除
	for (labelCustomButton*button in self.saveAllLabelArray) {
		[button removeFromSuperview];
	}
	[self.saveAllLabelArray removeAllObjects];
	
	
	
	if (self.Type==CusomterInfoDetail&&allLabelArray.count<1) {
		NoneButton=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bottomLabel.frame) + 5, 150, 15)];
		[NoneButton setTitle:@"为客户添加个性化标签" forState:UIControlStateNormal];
		NoneButton.titleLabel.font=[UIFont systemFontOfSize:14];
		[NoneButton setTitleColor:KNaviColor forState:UIControlStateNormal];
		[NoneButton addTarget:self action:@selector(clickToEditTagButton)];
		NoneButton.tag=917;
		[self addSubview:NoneButton];
		
		return;
	}
	
	
	
	
	
	
	
	CGFloat topValue=90;
	CGFloat leftValue=20;
	CGFloat horizonalSpace=10;
	CGFloat verticalSpace=10;
	CGFloat maxWith=KScreenWidth-20-20;
	CGSize size = [self.mainModel.C_ADDRESS boundingRectWithSize:CGSizeMake(KScreenWidth - 150, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} context:nil].size;
	if (self.mainModel.C_ADDRESS.length > 0) {
		topValue = topValue + size.height;
	}
	//多个加号图标
	
	if (self.Type==CusomterInfoDetail) {
		BOOL ownAdd = false;
		for ( CustomLabelModel*model in allLabelArray) {
			if ([model.title isEqualToString:@"加"]) {
				ownAdd=YES;
			}
			
			
		}
		
		
		if (ownAdd) {
			
		}else{
			CustomLabelModel*addModel=[[CustomLabelModel alloc]init];
			addModel.title=@"加";
			[allLabelArray addObject:addModel];
			
		}
		
	}
	
	
	
	
	for (CustomLabelModel*model in allLabelArray) {
		NSString*title=model.title;
		UIColor*currentColor=model.currentColor;
		
		CGFloat itemWith=[title boundingRectWithSize:CGSizeMake(maxWith, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+5+5 ;
		CGFloat itemHeight = 15 + 5;
		if ([model.title isEqualToString:@"加"]) {
			itemWith = itemWith + 5;
		}
		
		
		
		
		//底是80    需要加个10
		if (leftValue+itemWith<=maxWith) {
			
		}else{
			topValue=topValue+itemHeight+verticalSpace;
			
			leftValue=20;
		}
		
		//创建button
		labelCustomButton*button=[[labelCustomButton alloc]init];
		[button setTitle:title forState:UIControlStateNormal];
		button.layer.borderColor=currentColor.CGColor;
		
		
		[button setTitleColor:currentColor forState:UIControlStateSelected];
		[button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
		
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageWithColor:currentColor size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
		
		//self.height + 30 + 50
		button.frame=CGRectMake(leftValue, topValue, itemWith, itemHeight);
		[self addSubview:button];
		
		if (self.Type==CusomterInfoDetail&&[model.title isEqualToString:@"加"]) {
			[button setBackgroundImage:[UIImage imageNamed:@"icon_customer_details_add_lable"] forState:UIControlStateNormal];
			[button setTitleNormal:nil];
			[button normalButton];
			[button setWidth:button.width-10];
			
			
		}
		
		
		if (self.Type==CusomterInfoDetail) {
			[button addTarget:self action:@selector(clickToEditTagButton)];
			
		}
		
		
		
		//这里结束之后要给他赋值的
		
		leftValue=leftValue+itemWith+horizonalSpace;
		
		
		//保存所有的东西
		[self.saveAllLabelArray addObject:button];
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
}

-(NSMutableArray *)saveAllLabelArray{
	if (!_saveAllLabelArray) {
		_saveAllLabelArray=[NSMutableArray array];
	}
	return _saveAllLabelArray;
}




#pragma mark  -- funcation
+(CGFloat)headerHeight:(NSArray*)array andType:(CusomterInfo)Type{
	CGFloat topValue=90;
	CGFloat leftValue=20;
	CGFloat horizonalSpace=10;
	CGFloat verticalSpace=10;
	CGFloat maxWith=KScreenWidth-20-20;
	
	
	for (CustomLabelModel*model in array) {
		NSString*title=model.title;
		//        UIColor*currentColor=model.currentColor;
		
		CGFloat itemWith=[title boundingRectWithSize:CGSizeMake(maxWith, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+5+5;
		CGFloat itemHeight=15 + 5;
		
		
		
		//底是80    需要加个10
		if (leftValue+itemWith<=maxWith) {
			
		}else{
			topValue=topValue+itemHeight+verticalSpace;
			leftValue=20;
		}
		
		
		//这里结束之后要给他赋值的
		leftValue=leftValue+itemWith+horizonalSpace;
		
		
		
		
	}
	
	
	
	if (Type==CusomterInfoDetail&&array.count<1) {
		return topValue;
		
	}
	
	
	
	if (array.count<1) {
		return topValue;
	}
	return topValue+20;
	
}


@end
