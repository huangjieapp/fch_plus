//
//  MJKRedPackageView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKRedPackageView.h"
#import "MJKRedPackageModel.h"

@interface MJKRedPackageView ()
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation MJKRedPackageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [super setFrame:frame];
}

- (void)initUI {
    UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor clearColor];
//    bgView.alpha = .5f;
    [self addSubview:bgView];
    
    UIImage *image = [UIImage imageNamed:@"红包图片"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - image.size.width) / 2, (KScreenHeight - image.size.height) / 2, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openRedPackageAction)];
    [self addSubview:button];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame) + 10, CGRectGetMinY(button.frame) + 50, button.frame.size.width - 20, 0)];
    self.titleLabel.font = [UIFont systemFontOfSize:18.f];
    self.titleLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxX(self.titleLabel.frame) + 10, button.frame.size.width - 20, 20)];
    self.subTitleLabel.font = [UIFont systemFontOfSize:14.f];
    self.subTitleLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    self.subTitleLabel.text = @"您获得了一笔奖励,请继续加油哦";
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.subTitleLabel];
    
}

- (void)setModel:(MJKRedPackageModel *)model {
    _model = model;
    
    CGFloat titleHeight = [model.C_VOUCHERNAME boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.f]} context:nil].size.height;
    self.titleLabel.text = model.C_VOUCHERNAME;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height = titleHeight;
    self.titleLabel.frame = titleFrame;
    
    CGRect subTitleFrame = self.subTitleLabel.frame;
    subTitleFrame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + 10;
    self.subTitleLabel.frame = subTitleFrame;
    
}

- (void)openRedPackageAction {
    if (self.openRedPackageBlock) {
        self.openRedPackageBlock();
    }
    [self removeFromSuperview];
}

@end
