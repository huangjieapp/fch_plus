//
//  MJKBusinessCardAlertView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessCardAlertView.h"

@interface MJKBusinessCardAlertView ()
/** <#备注#>*/
@property (nonatomic, copy) void(^actionBlock)(NSString * buttonTitle);
@end

@implementation MJKBusinessCardAlertView

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray colorArray:(NSArray *)colorArray clickActionBlock:(void (^)(NSString * _Nonnull buttonTitle))actionBlock {
    if (self = [super init]) {
        self.actionBlock = actionBlock;
        UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = .5f;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [bgView addGestureRecognizer:tapGR];
        [self addSubview:bgView];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(10, 200, KScreenWidth - 20, 200)];
        alertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:alertView];
        
        for (int i = 0; i < buttonArray.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (alertView.frame.size.width / buttonArray.count), alertView.frame.size.height - 40, alertView.frame.size.width / buttonArray.count, 40)];
            [button setTitleNormal:buttonArray[i]];
            [button setBackgroundColor:colorArray[i]];
            [button setTitleColor:[UIColor blackColor]];
            [button addTarget:self action:@selector(buttonAction:)];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [alertView addSubview:button];
        }
        
        if (title.length > 0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, alertView.frame.size.width - 20, 30)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = title;
            [alertView addSubview:label];
            
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), alertView.frame.size.width, 1)];
            sepView.backgroundColor = kBackgroundColor;
            [alertView addSubview:sepView];
            
            UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(sepView.frame), alertView.frame.size.width - 20, alertView.frame.size.height - 40 - label.frame.size.height - 1)];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:14.f];
            messageLabel.text = message;
            messageLabel.numberOfLines = 0;
            
            [alertView addSubview:messageLabel];
        } else {
            UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, alertView.frame.size.width - 20, alertView.frame.size.height - 40)];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:14.f];
            messageLabel.text = message;
            messageLabel.numberOfLines = 0;
            
            [alertView addSubview:messageLabel];
        }
    }
    return self;
}

- (void)closeView {
    if (self.closeViewActionBlock) {
        self.closeViewActionBlock();
    }
    [self removeFromSuperview];
}

- (void)buttonAction:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(sender.titleLabel.text);
    }
    [self removeFromSuperview];
}

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [super setFrame:frame];
}

@end
