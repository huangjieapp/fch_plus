//
//  AddBrokerView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BROKERBLOCK)(NSString*type,NSString *value);

@interface AddBrokerView : UIView

+(instancetype)getView;

@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *telText;

@property (weak, nonatomic) IBOutlet UIButton *canelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, copy) BROKERBLOCK broBlock;

- (void)showView;
@end
