//
//  MJKShowSendView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShowSendView.h"

@implementation MJKShowSendView

- (instancetype)initWithFrame:(CGRect)frame andButtonTitleArray:(NSArray *)buttonArray andTitle:(NSString *)titleStr andMessage:(NSString *)message {
    if (self = [super initWithFrame:frame]) {
        [self initUIWithFrame:frame andButtonTitleArray:buttonArray andTitle:titleStr andMessage:message];
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame andButtonTitleArray:(NSArray *)buttonArray andTitle:(NSString *)titleStr andMessage:(NSString *)message {
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .5f;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [bgView addGestureRecognizer:tapGR];
    CGFloat supHeight = 150;
    if (titleStr.length > 0) {
        supHeight = 180;
    }
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(30, (KScreenHeight - 150) / 2, KScreenWidth - 60, supHeight)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.cornerRadius = 5.f;
    showView.layer.masksToBounds = YES;
    [self addSubview:showView];
    
    if (titleStr.length > 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 30)];
        titleLabel.text = titleStr;
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [showView addSubview:titleLabel];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), showView.frame.size.width, 1)];
        sepView.backgroundColor = kBackgroundColor;
        [showView addSubview:sepView];
    }
    
    CGFloat messageY = 5;
    if (titleStr.length > 0) {
        messageY = 30;
    }
    CGFloat messageHeight = 150;
    if (buttonArray.count > 0) {
        messageHeight = 100;
    }
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, messageY, showView.frame.size.width - 10, messageHeight)];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = [UIFont systemFontOfSize:14.f];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:messageLabel];
    
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (showView.frame.size.width / buttonArray.count), showView.frame.size.height - 50, showView.frame.size.width / buttonArray.count, 50)];
        [button setTitleNormal:buttonArray[i]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleColor:[UIColor blackColor]];
        if (buttonArray.count == 1) {
            [button setBackgroundColor:KNaviColor];
        } else {
            if (i == 0) {
                [button setBackgroundColor:kBackgroundColor];
            } else {
                [button setBackgroundColor:KNaviColor];
            }
        }
        
        [button addTarget:self action:@selector(buttonAction:)];
        [showView addSubview:button];
    }
}

- (void)closeView {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(@"否");
    }
    if (self.isFkr == NO) {
        [self removeFromSuperview];
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender.titleLabel.text);
    }
    [self removeFromSuperview];
}

@end
