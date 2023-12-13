//
//  MJKSocialFKHeaderView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSocialFKHeaderView.h"

@interface MJKSocialFKHeaderView ()
/** firstLabel*/
@property (nonatomic, strong) UILabel *firstLabel;
@end

@implementation MJKSocialFKHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, self.frame.size.height)];
    self.firstLabel = label;
    label.font = [UIFont systemFontOfSize:12.f];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"员工";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    CGFloat width = (KScreenWidth - self.firstLabel.frame.size.width) / titleArray.count;
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.firstLabel.frame) + (i * width), 0, width, self.frame.size.height)];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor darkGrayColor];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

@end
