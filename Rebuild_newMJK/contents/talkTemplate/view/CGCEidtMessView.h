//
//  CGCEidtMessView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/21.
//  Copyright © 2017年 月见黑. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^CANELMBLOCK)();
typedef void(^SUREMBLOCK)(NSString * title,NSString * desc);


@interface CGCEidtMessView : UIView



@property (weak, nonatomic) IBOutlet UIButton *bgBtn;


@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;


@property (weak, nonatomic) IBOutlet UIButton *canelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextField *desText;

@property (weak, nonatomic) IBOutlet UITextView *descTextView;


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withDesStr:(NSString *)des withCanel:(CANELCLICK)canel withSure:(SUREMBLOCK)sure;

@end
