//
//  CloseDealView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloseDealView : UIView
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourthTextF;

@property(nonatomic,copy)void(^clickCancelBlock)();
@property(nonatomic,copy)void(^clickSureBlock)(NSString*firstStr,NSString*secondStr,NSString*thirdStr,NSString*fourthStr);

@end
