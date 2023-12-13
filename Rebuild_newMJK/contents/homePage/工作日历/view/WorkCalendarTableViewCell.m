//
//  WorkCalendarTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "WorkCalendarTableViewCell.h"

@interface WorkCalendarTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *addressStr;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@end


@implementation WorkCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}


#pragma mark  --set
-(void)setMainModel:(WorkCalendarModel *)mainModel{
    _mainModel=mainModel;
    self.leftTopLabel.text=mainModel.X_REMARK;
    self.leftBottomLabel.text=mainModel.C_A41500_C_NAME;
    self.rightBottomLabel.text=mainModel.C_OWNER_ROLENAME;
	self.addressStr.text = mainModel.C_ADDRESS;
	
    //这个有改颜色。
    self.statusLabel.text=mainModel.TYPE_NAME;
    if ([mainModel.TYPE_NAME isEqualToString:@"备忘"]) {
        self.statusLabel.textColor=DBColor(252, 89, 91);
    }else if ([mainModel.TYPE_NAME isEqualToString:@"客户跟进"]){
        self.statusLabel.textColor=DBColor(124, 215, 123);
	} else if ([mainModel.TYPE_NAME isEqualToString:@"订单跟进"]) {
		self.statusLabel.textColor=DBColor(255,147,159);
		//		self.statusLabel.backgroundColor = [UIColor clearColor];
	} else if ([mainModel.TYPE_NAME isEqualToString:@"协助跟进"]) {
		self.statusLabel.textColor=DBColor(240,173,78);
    } else if ([mainModel.TYPE_NAME isEqualToString:@"任务"]) {
        //FF939F
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#FF939F"];
		
    } else if ([mainModel.TYPE_NAME isEqualToString:@"粉丝跟进"]) {
        
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#C68EEF"];
    }
	else{
        //签到
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#4BB0C4"];
    }
    
    
    //mainModel.X_REMARK
	
    NSString*markStr=[mainModel.TYPE_NAME isEqualToString:@"任务"] ? mainModel.X_RW_REMARK : mainModel.X_REMARK;
    if (!markStr) {
        markStr=@"";
    }
    
    NSMutableAttributedString*bb=[[NSMutableAttributedString alloc]initWithString:markStr attributes:@{NSForegroundColorAttributeName:DBColor(192, 192, 192),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
   


    
    if ([mainModel.C_PROCESS isEqualToString:@"未处理"]) {
        [bb addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, bb.length)];
        self.leftTopLabel.attributedText=bb;
//        self.leftTopLabel.text=mainModel.X_REMARK;
        
    }else{
//        self.leftTopLabel.text=nil;
        //已处理  需要改变颜色和文字加上横线
       //#2. //文字上 横线
        
//         NSMutableAttributedString*bb=[[NSMutableAttributedString alloc]initWithString:markStr];
        
        [bb addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, bb.length)];
        [bb addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, bb.length)];


        [self.leftTopLabel setAttributedText:bb];
        
    }
	
	
	
	self.statusLabel.backgroundColor = [UIColor clearColor];
	
	[self.addressStr mas_makeConstraints:^(MASConstraintMaker *make) {		make.width.mas_equalTo(180);
	}];
}


@end
