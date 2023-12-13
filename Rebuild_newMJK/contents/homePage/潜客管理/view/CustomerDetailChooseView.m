//
//  CustomerDetailChooseView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailChooseView.h"

@implementation CustomerDetailChooseView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.topLabel.textColor=DBColor(211, 211, 211);
    
    //选中的话 115  115  115
    
    
}



-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self=[[NSBundle mainBundle]loadNibNamed:@"CustomerDetailChooseView" owner:nil options:nil].firstObject;
        self.frame=frame;
        
        
//        UIButton*clearButton=[[UIButton alloc]initWithFrame:self.frame];
//        clearButton.backgroundColor=[UIColor clearColor];
//        [clearButton addTarget:self action:@selector(clickButton:)];
//        [self addSubview:clearButton];
        
        
    }
    return self;
}


//-(void)clickButton:(UIButton*)sender{
//    sender.selected=!sender.selected;
//    
//}




#pragma mark  --set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.topLabel.text=titleStr;
    
}

-(void)setNumberStr:(NSString *)numberStr{
    _numberStr=numberStr;
    self.bottomLabel.text=numberStr;
}

@end
