//
//  ZZShareView.m
//  uliaobao
//
//  Created by wisdom on 16/2/23.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ZZShareView.h"
#import "WXApi.h"

//#import <UMShare/UMShare.h>
//#import <UMSocialQQHandler.h>

@interface ZZShareView ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZZShareView



- (instancetype)initWithdelegate:(id<ZZShareDelegate>)delegate
{
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDE, HIGHT)]) {
        self.delegate=delegate;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black"]];
        [self createShareView];
    }
    return self;
}

- (instancetype)initWithdelegate:(id<ZZShareDelegate>)delegate withArr:(NSArray *)arr
{
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDE, HIGHT)]) {
        self.delegate=delegate;
        self.dataArray=[NSMutableArray arrayWithArray:arr];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black"]];
        [self createShareView];
    }
    return self;
}


- (void)createShareView
{
    UIButton *bacBtn=[DBTools creatButtonWithFrame:CGRectMake(0, 0, WIDE, HIGHT) Target:self Sel:@selector(cancel) Title:nil ImageName:nil BGImageName:nil];
    [self addSubview:bacBtn];
    
    UIImageView *bacView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-200, WIDE, 200)];
    bacView.image=[UIImage imageNamed:@"色块"];
    bacView.userInteractionEnabled=YES;
    [bacBtn addSubview:bacView];

    UILabel *shareLabel=[DBTools createLabelWithFrame:CGRectMake((WIDE-100)/2, 20, 100, 20) Font:12 Text:@"分享给小伙伴们"];
    shareLabel.textColor = COLOR_242526;
    shareLabel.textAlignment=NSTextAlignmentCenter;
    [bacView addSubview:shareLabel];
    NSMutableArray *imageArr=[[NSMutableArray alloc]initWithObjects:@"微信好友",@"icon_share_pyq",@"icon_share_screen", nil];
//,@"QQ好友",@"投屏"
    if (self.dataArray.count > 0) {
        self.keyWordArr=[[NSMutableArray alloc]initWithArray:self.dataArray];
        imageArr = [self.dataArray copy];
    } else {
        if (self.dataArray.count==1) {
            self.keyWordArr=[[NSMutableArray alloc]initWithObjects:@"微信好友", nil];
        }else{
            self.keyWordArr=[[NSMutableArray alloc]initWithObjects:@"微信好友",@"朋友圈",@"投屏", nil];
        }
    }
  
    for (int i=0; i<self.keyWordArr.count; i++) {
        UIButton *shareBtn=[DBTools creatButtonWithFrame:CGRectMake(0, 60, 70, 80) Target:self Sel:@selector(btn:) Title:self.keyWordArr[i] ImageName:imageArr[i] BGImageName:nil];
        shareBtn.center=CGPointMake(WIDE/(self.keyWordArr.count*2)*(2*i+1), 100);
        shareBtn.tintColor=COLOR_81838B;
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        shareBtn.imageEdgeInsets=UIEdgeInsetsMake(-15, 10, 0, 0);
        shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0,-50, -60, 0);
        [bacView addSubview:shareBtn];
    }
   
    //分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bacView.frame.size.height - 49, WIDE, 1)];
    line.backgroundColor = COLOR_F0F2F4;
    [bacView addSubview:line];
    
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bacView.frame.size.height - 50, WIDE, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cancelBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bacView addSubview:cancelBtn];
} 

//分享
- (void)btn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selectBtn:withButtonTitle:)]) {
        [self.delegate selectBtn:self withButtonTitle:button.titleLabel.text];
    }
    if([button.currentTitle isEqualToString:@"微信好友"])
    {
        if([WXApi isWXAppInstalled])
        {
            [self removeFromSuperview];
        }else{
//            [POPHUD showError:@"请先安装微信"];
        }
        
    }else if([button.currentTitle isEqualToString:@"QQ好友"])
    {
       
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
             [self removeFromSuperview];
            
        }else{
//            [POPHUD showError:@"请先安装QQ"];
        }
        

        
    }else if([button.currentTitle isEqualToString:@"朋友圈"])
    {
        if([WXApi isWXAppInstalled])
        {
            [self removeFromSuperview];
        }else{
//            [POPHUD showError:@"请先安装微信"];
        }
    }
    
   
 

}



#pragma mark --取消

- (void)cancel
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
