//
//  CGCShowWXHY.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WXHYBLOCK)(NSString * title);


@interface CGCShowWXHY : UIView
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UIImageView *img;


@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic, copy) WXHYBLOCK wBlock;

+(instancetype)getView;
- (void)dismissView;
- (void)showView;
@end
