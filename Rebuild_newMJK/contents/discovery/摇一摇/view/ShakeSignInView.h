//
//  ShakeSignInView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/6.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeSignInView : UIView
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

+(instancetype)creatShakeSignInView;
@property(nonatomic,strong)void(^clickCompleteBlock)(NSString*textStr);


@end
