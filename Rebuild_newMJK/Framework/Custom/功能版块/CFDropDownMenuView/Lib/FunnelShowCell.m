//
//  FunnelShowCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "FunnelShowCell.h"
#import "FunnelCustomButton.h"

#import "MJKFunnelMoreView.h"

#import "PotentailCustomerListViewController.h"
#import "CGCOrderListVC.h"
#import "MJKHomePageNewViewController.h"
#import "MJKGroupReportViewController.h"

@interface FunnelShowCell()

@property(nonatomic,strong)NSMutableArray*saveAllButtonArray;   //保存所有的button  用来移除
@property(nonatomic,strong)UILabel*titleLabel;

@end

@implementation FunnelShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, KScreenWidth/2, 20)];
        titleLabel.text=@"标题标题";
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=[UIColor blackColor];
        self.titleLabel=titleLabel;
        [self.contentView addSubview:titleLabel];
        UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 100 - 150, 0, 140, 40)];
		[moreButton setTitleNormal:@"更多>>"];
		moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		[moreButton setTitleColor:[UIColor darkGrayColor]];
		moreButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
		[moreButton addTarget:self action:@selector(moreAction:)];
		self.moreButton = moreButton;
		[self.contentView addSubview:moreButton];
        
        
    }
    return  self;
}

- (void)moreAction:(UIButton *)sender {
    
    if (self.gotoBlock) {
        self.gotoBlock();
        return;
    }
	MJKFunnelMoreView *moreView = [[MJKFunnelMoreView alloc]initWithFrame:CGRectMake(50, 0, KScreenWidth - 50, KScreenHeight)];
	[[UIApplication sharedApplication].keyWindow addSubview:moreView];
	moreView.dataArray = self.allDataArray;
	moreView.backModelArrayBlock = ^(NSArray *modelArray) {
		self.allDataArray = modelArray;
		
		for (MJKFunnelChooseModel *model in modelArray) {
			if (model.isSelected == YES) {
				[self.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",model.name]];
				if ([model.c_id isEqualToString:@"999"]) {
					if (self.customTimeBlock) {
						self.customTimeBlock();
					}
				}
				if ([model.c_id isEqualToString:@"111"]) {
					if (self.indexTimeBlock) {
						self.indexTimeBlock();
					}
				}
				if ([model.c_id isEqualToString:@"222"]) {
					if (self.TimeBlock) {
						self.TimeBlock();
					}
				}
			}
		}
	};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}


- (void)setButtonNoSelected:(BOOL)buttonNoSelected {
    _buttonNoSelected = buttonNoSelected;
    for (int i=0; i<self.allDataArray.count; i++) {
        MJKFunnelChooseModel*model=self.allDataArray[i];
        
            model.isSelected=NO;
        
        
    }
}

#pragma mark  --click
-(void)clickButton:(FunnelCustomButton*)funnelButton{
    NSInteger number=funnelButton.tag-1000;
    MyLog(@"%lu",number);
	
	
    [self.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",funnelButton.titleLabel.text]];
    
    
    
    for (FunnelCustomButton*button in self.saveAllButtonArray) {
        if (button.tag-1000==number) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }
        
    }
    
    
   
    for (int i=0; i<self.allDataArray.count; i++) {
        MJKFunnelChooseModel*model=self.allDataArray[i];
        
        if (i==number) {
            
            model.isSelected=YES;
           
        }else{
            model.isSelected=NO;
        }
   
        
    }
    if (self.chooseNormalButtonBlock) {
        self.chooseNormalButtonBlock();
    }
    
    
        // C_id  如果是  999   那么这里  就触发时间选择block
   MJKFunnelChooseModel*currentModel=self.allDataArray[number];
    if ([currentModel.c_id isEqualToString:@"999"]) {
        if (self.customTimeBlock) {
            self.customTimeBlock();
        }
        
    }
    if ([currentModel.c_id isEqualToString:@"111"]) {
        if (self.indexTimeBlock) {
            self.indexTimeBlock();
        }
        
    }if ([currentModel.c_id isEqualToString:@"222"]) {
        if (self.TimeBlock) {
            self.TimeBlock();
        }
        
    }
    
    
    
  


    
    
    
}


#pragma mark  --set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.titleLabel.text=titleStr;
    if ([self.rootVC isKindOfClass:[PotentailCustomerListViewController class]]) {
        if ([self.titleStr isEqualToString:@"客户列表排序"]) {
            self.moreButton.hidden = YES;
        }
    }
    
}


-(void)setAllDataArray:(NSArray *)allDataArray{
    _allDataArray=allDataArray;
    
    NSArray *pxArr = @[@"",@"创建时间",@"活跃时间",@"下次跟进时间",@"等级",@"首字母"];
    NSArray *pxCodeArr = @[@"",@"A47500_C_KHPX_0004",@"A47500_C_KHPX_0000",@"A47500_C_KHPX_0001",@"A47500_C_KHPX_0002",@"A47500_C_KHPX_0003"];
     NSArray*arraySel=@[@"",@"5",@"0",@"1",@"2",@"4"];
    
    //先移除
    for (FunnelCustomButton*button in self.saveAllButtonArray) {
        [button removeFromSuperview];
    }
    [self.saveAllButtonArray removeAllObjects];
    
    // 从40 的地方开始
    NSInteger topValue=40;
    NSInteger leftValue=10;
    NSInteger horizontalSpace=20;
    NSInteger verticalSpace=15;
//    NSInteger maxWith=KScreenWidth-100-10-10;  //最后一个减少20是 偏移
	NSInteger maxWith = (KScreenWidth - 50 - 2 * leftValue - 2 * horizontalSpace) / 3;
    for (int i=0; i<allDataArray.count; i++) {
		if (i > 5) {
			return;
		}
        MJKFunnelChooseModel*model=allDataArray[i];
        NSString*title=model.name;
//        BOOL isSelected=model.isSelected;
//
        CGFloat labelButtonHeight=35;
//        CGFloat labelButtonWith=[title boundingRectWithSize:CGSizeMake(maxWith, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+20;   //左右个余留了5
//        if ((leftValue+labelButtonWith)<=maxWith) {
//
//
//        }else{
//            topValue=topValue+verticalSpace+labelButtonHeight;
//            leftValue=10;
//        }
//
//
//
		
        FunnelCustomButton*button=[[FunnelCustomButton alloc]init];
        button.tag=1000+i;
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButton:)];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        /*
         A7500_C_KHPX_0000    客户活跃时间
         A47500_C_KHPX_0001    客户下次跟进时间
         A47500_C_KHPX_0002    客户等级
         A47500_C_KHPX_0003    客户首字母
         */
        //客户列表排序
        if ([self.rootVC isKindOfClass:[PotentailCustomerListViewController class]]) {
            NSString *str = pxCodeArr[i];
            NSString *codeStr = arraySel[i];
            if ([str isEqualToString:[NewUserSession instance].configData.C_KHPX] || [codeStr isEqualToString:[NewUserSession instance].configData.C_KHPX]) {
                if ([model.name isEqualToString:pxArr[i]]) {
                    model.isSelected = YES;
                }
            }
        }
        if ([self.rootVC isKindOfClass:[CGCOrderListVC class]]) {
            if ([model.name isEqualToString:[KUSERDEFAULT objectForKey:@"C_SORTIDXTYPE"]]) {
                model.isSelected = YES;
            }
        }
        if ([self.rootVC isKindOfClass:[MJKHomePageNewViewController class]]) {
            if ([model.name isEqualToString:[KUSERDEFAULT objectForKey:@"funnelSelectValue"]]) {
                model.isSelected = YES;
            }
            if ([model.name isEqualToString:[KUSERDEFAULT objectForKey:@"timeName"]]) {
                model.isSelected = YES;
            }
        }
        if ([self.rootVC isKindOfClass:[MJKGroupReportViewController class]]) {
            if ([model.name isEqualToString:[KUSERDEFAULT objectForKey:@"groupfunnelSelectValue"]]) {
                model.isSelected = YES;
            }
            if ([model.name isEqualToString:[KUSERDEFAULT objectForKey:@"grouptimeName"]]) {
                model.isSelected = YES;
            }
        }
        
        //
        CGFloat labelButtonWith = (KScreenWidth - 100 - 2 * leftValue - 2 *horizontalSpace) / 3;
        button.frame=CGRectMake(leftValue + (i % 3) * (labelButtonWith + horizontalSpace), topValue + topValue * (i / 3), labelButtonWith, labelButtonHeight);
        [self.contentView addSubview:button];
        button.selected=model.isSelected;
        
        if (model.isSelected == YES) {
            [self.moreButton setTitleNormal:[NSString stringWithFormat:@"%@>>",model.name]];
        }
        
        
        //这里结束之后要给他赋值的
//        leftValue=leftValue+labelButtonWith+horizontalSpace;
		
        
        //保存所有的东西
        [self.saveAllButtonArray addObject:button];
        
        
    }
    
    
    
    
    
}




-(NSMutableArray *)saveAllButtonArray{
    if (!_saveAllButtonArray) {
        _saveAllButtonArray=[NSMutableArray array];
    }
    return _saveAllButtonArray;
    
}





#pragma mark  -- function
+(CGFloat)cellHeightWithArray:(NSArray*)labelArray{
    
    
  /*  // 从40 的地方开始
    NSInteger topValue=40;
    NSInteger leftValue=10;
    NSInteger horizontalSpace=20;
    NSInteger verticalSpace=15;
    NSInteger maxWith=KScreenWidth-100-10-10;  //最后一个减少20是 偏移
	
    for (int i=0; i<(labelArray.count > 5 ? 5 : labelArray.count-1); i++) {
		
        MJKFunnelChooseModel*model=labelArray[i];
        
        
        NSString*title=model.name;
        BOOL isSelected=model.isSelected;
        
        
        
        CGFloat labelButtonHeight=35;
//        CGFloat labelButtonWith=[title boundingRectWithSize:CGSizeMake(maxWith, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+20;   //左右个余留了5
		CGFloat labelButtonWith = (KScreenWidth - 100 - 2 * 10 - 2 *horizontalSpace) / 3;
        if ((leftValue+labelButtonWith)<=maxWith) {
            
            
        }else{
            topValue=topValue+verticalSpace+labelButtonHeight;
            leftValue=10;
        }
        
        
        
        
        
        //这里结束之后要给他赋值的
        leftValue=leftValue+labelButtonWith+horizontalSpace;
        
    }*/
	if (labelArray.count > 3) {
		return 140;
	} else {
		return 90;
	}
    
//    return topValue+40+10;   //20是文字的高  10 是底部再来点高
}



@end
