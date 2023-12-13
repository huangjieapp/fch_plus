//
//  CGCPersonalInfoView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TELBLOCK)();
typedef void(^MESSBLOCK)();

@interface CGCPersonalInfoView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (weak, nonatomic) IBOutlet UIButton *mesBtn;

@property (nonatomic, copy) TELBLOCK telB;

@property (nonatomic, copy) MESSBLOCK messB;

- (instancetype)initWithFrame:(CGRect)frame withTel:(TELBLOCK)telBlock withMess:(MESSBLOCK)messBlock;

@end
