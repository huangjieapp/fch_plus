//
//  VerificationHeadView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VERBLOCK)(NSString * titStr);

@interface VerificationHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (weak, nonatomic) IBOutlet UIButton *messBtn;

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (weak, nonatomic) IBOutlet UILabel *storeLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, copy) VERBLOCK verBlock;

+(instancetype)getView;

@end
