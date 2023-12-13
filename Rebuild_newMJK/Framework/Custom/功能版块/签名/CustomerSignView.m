//
//  CustomerSignView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/2.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "CustomerSignView.h"
#import "SignatureView.h"

@interface CustomerSignView()
@property (nonatomic, strong) SignatureView *signView;

@property(nonatomic,copy)getImageBlock getImageBlock;
@end

@implementation CustomerSignView


+(instancetype)signViewShowSuccess:(getImageBlock)imageBlock{
    CustomerSignView*signView=[[CustomerSignView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    signView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    signView.getImageBlock=imageBlock;
    
    
    UIButton*dismissButton=[[UIButton alloc]initWithFrame:signView.frame];
    dismissButton.backgroundColor=[UIColor clearColor];
    [dismissButton addTarget:signView action:@selector(clickDismiss)];
    [signView addSubview:dismissButton];
    
    
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-30, KScreenWidth-30+20+40)];
    mainView.centerY=signView.centerY;
    mainView.backgroundColor=[UIColor whiteColor];
    [signView addSubview:mainView];
    
    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.width, 20)];
    topView.backgroundColor=DBColor(247, 247, 247);
    [mainView addSubview:topView];
    UILabel*topLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth/2, 20)];
    topLab.font=[UIFont systemFontOfSize:14];
    topLab.textColor=DBColor(142, 142, 142);
    topLab.text=@"客户签名";
    [mainView addSubview:topLab];
    
    signView.signView = [[SignatureView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth-30, KScreenWidth-30)];
    [mainView addSubview:signView.signView];

    UIButton*cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, mainView.height-40, mainView.width/2, 40)];
    [cancelButton setBackgroundColor:DBColor(247, 247, 247)];
    [cancelButton setTitleColor:DBColor(142, 142, 142)];
    [cancelButton setTitleNormal:@"取消"];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [cancelButton addTarget:signView action:@selector(clickDismiss)];
    [mainView addSubview:cancelButton];
    
    UIButton*sureButton=[[UIButton alloc]initWithFrame:CGRectMake(mainView.width/2, mainView.height-40, mainView.width/2, 40)];
    [sureButton setBackgroundColor:DBColor(247, 247, 247)];
    [sureButton setTitleColor:[UIColor blackColor]];
    [sureButton setTitleNormal:@"确定"];
     sureButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [sureButton addTarget:signView action:@selector(clickGetImage)];
    [mainView addSubview:sureButton];

  
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, mainView.height-40, mainView.width, 1)];
    lineView.backgroundColor=DBColor(200, 199, 204);
    [mainView addSubview:lineView];
    
    UIView*VlineView=[[UIView alloc]initWithFrame:CGRectMake(mainView.width/2, mainView.height-40, 1, 40)];
    VlineView.backgroundColor=DBColor(200, 199, 204);
    [mainView addSubview:VlineView];
    
    return signView;
}



#pragma mark  --click
-(void)clickDismiss{
    [self removeFromSuperview];
}


-(void)clickGetImage{
   UIImage*image=[self.signView saveScreen];
    if (self.getImageBlock) {
        self.getImageBlock(image);
    }
    [self clickDismiss];
    
}


@end
