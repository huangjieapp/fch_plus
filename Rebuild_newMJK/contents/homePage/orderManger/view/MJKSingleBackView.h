//
//  MJKSingleBackView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKSingleBackView : UIView
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *tureButton;
- (instancetype)initWithFrame:(CGRect)frame andReasonBlock:(void(^)(NSString *type, NSString *timeStr, NSString *Remark))reasonBlock;
@end
