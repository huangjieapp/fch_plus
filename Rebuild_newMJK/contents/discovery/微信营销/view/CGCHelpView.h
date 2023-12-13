//
//  CGCHelpView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PICBLOCK)(UILabel *lab,UIButton *btn,UILabel *des);
typedef void(^SENDBLOCK)(UIButton *btn);

@interface CGCHelpView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UILabel *lab3;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UIButton *disSend;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *helpBtn;





-(instancetype)initWithFrame:(CGRect)frame withPicB:(PICBLOCK)picB withSendB:(SENDBLOCK)sendB;
@end
