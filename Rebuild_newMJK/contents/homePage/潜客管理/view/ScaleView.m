//
//  ScaleView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "ScaleView.h"

@interface ScaleView()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *subView;

//潜客
@property(nonatomic,strong)CustomerDetailPathDetailModel*mainModel;


//签到
@property(nonatomic,strong)WorkCalendarModel*signModel;

//付款记录
@property(nonatomic,strong)NSString*textStr;

@end

@implementation ScaleView

+(instancetype)scaleViewWithModel:(CustomerDetailPathDetailModel*)mainModel{
    ScaleView*mainView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    mainView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    mainView.mainModel=mainModel;
    mainView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    

    
    return mainView;
}


+(instancetype)ScaleSignWithModel:(WorkCalendarModel*)model{
     ScaleView*mainView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    mainView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    mainView.signModel=model;
    mainView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    
    return mainView;
}

//付款记录放大  文字放大
+(instancetype)ScaleStringWith:(NSString*)textStr{
    ScaleView*mainView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    mainView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    mainView.textStr=textStr;
    mainView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
     return mainView;
}



#pragma mark  --click
-(void)clickDismiss{
    [self removeFromSuperview];
}



#pragma mark  --set
-(void)setMainModel:(CustomerDetailPathDetailModel *)mainModel{
    _mainModel=mainModel;
    //总高是  40+10+10   + label 的高度
    self.timeLabel.text=mainModel.D_SHOW_TIME;
    self.nameLabel.text=mainModel.C_TYPE;
    self.textLabel.text=mainModel.X_REMARK;
    self.textLabel.numberOfLines=0;
    
   CGFloat textHeight=[mainModel.X_REMARK boundingRectWithSize:CGSizeMake(self.textLabel.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGRect subViewFrame=self.subView.frame;
    subViewFrame.size.height=textHeight;
    self.subView.frame=subViewFrame;
    
    CGRect textViewFrame=self.textLabel.frame;
    textViewFrame.size.height=textHeight;
    self.textLabel.frame=textViewFrame;
    
//    [self.subView setHeight:60+textHeight];
//    [self.textLabel setHeight:textHeight];
    
    
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDismiss)];
        [self addGestureRecognizer:tap];
    
    [self.cancelButton addTarget:self action:@selector(clickDismiss)];
    
}



-(void)setSignModel:(WorkCalendarModel *)signModel{
    _signModel=signModel;
    //总高是  40+10+10   + label 的高度
    self.timeLabel.hidden=YES;
    self.nameLabel.hidden=YES;
    self.textLabel.text=signModel.X_REMARK;
    self.textLabel.numberOfLines=0;
    
    
    CGFloat textHeight=[signModel.X_REMARK boundingRectWithSize:CGSizeMake(self.textLabel.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGRect subViewFrame=self.subView.frame;
    subViewFrame.size.height=textHeight;
    self.subView.frame=subViewFrame;
    
    CGRect textViewFrame=self.textLabel.frame;
    textViewFrame.size.height=textHeight;
    self.textLabel.frame=textViewFrame;
    
    //    [self.subView setHeight:60+textHeight];
    //    [self.textLabel setHeight:textHeight];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDismiss)];
    [self addGestureRecognizer:tap];
    
    [self.cancelButton addTarget:self action:@selector(clickDismiss)];
    
    
}

-(void)setTextStr:(NSString *)textStr{
    _textStr=textStr;
    //总高是  40+10+10   + label 的高度
    self.timeLabel.hidden=YES;
    self.nameLabel.hidden=YES;
    self.textLabel.text=textStr;
    self.textLabel.numberOfLines=0;
    
    
    CGFloat textHeight=[textStr boundingRectWithSize:CGSizeMake(self.textLabel.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGRect subViewFrame=self.subView.frame;
    subViewFrame.size.height=textHeight;
    self.subView.frame=subViewFrame;
    
    CGRect textViewFrame=self.textLabel.frame;
    textViewFrame.size.height=textHeight;
    self.textLabel.frame=textViewFrame;
    
    //    [self.subView setHeight:60+textHeight];
    //    [self.textLabel setHeight:textHeight];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDismiss)];
    [self addGestureRecognizer:tap];
    
    [self.cancelButton addTarget:self action:@selector(clickDismiss)];
    
    
    
}


@end
