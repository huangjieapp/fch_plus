//
//  TopImageButton.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBTopImageBottomLabelButton.h"
@interface DBTopImageBottomLabelButton()


@end

@implementation DBTopImageBottomLabelButton

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self creat];
}


-(instancetype)initWithFrame:(CGRect)frame{
   self= [super initWithFrame:frame];
    if (self) {
        [self creat];
    }
    return self;
}


-(void)creat{
//    CGFloat buttonWith=self.size.width;
//    CGFloat buttonHeight=self.size.height*40/70;
    
    self.TopImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.height*50/70, self.height*50/70)];
    self.TopImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.TopImageView.centerX=self.width/2;
    [self addSubview:self.TopImageView];
    
    self.BottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.TopImageView.bottom+3, self.width, self.height-self.TopImageView.bottom-3)];
    self.BottomLabel.textColor =[UIColor lightGrayColor];
    self.BottomLabel.textAlignment = NSTextAlignmentCenter;  //文字居中
    self.BottomLabel.adjustsFontSizeToFitWidth = YES;   //文字大小自适应
    self.BottomLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.BottomLabel];

    
}



@end
