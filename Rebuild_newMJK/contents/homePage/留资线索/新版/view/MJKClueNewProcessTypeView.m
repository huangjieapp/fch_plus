//
//  MJKClueNewProcessTypeView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKClueNewProcessTypeView.h"

@interface MJKClueNewProcessTypeView ()
/** <#注释#>*/
@property (nonatomic, strong) UIView *selectBGView;
@end

@implementation MJKClueNewProcessTypeView

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        [self initUIWithFrame:frame andTitleArray:titleArray];
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray {
    UIView *sepBgView;
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / titleArray.count), 0, KScreenWidth / titleArray.count, 35)];
        [button setTitleNormal:titleArray[i]];
        [button setTitleColor:[UIColor darkGrayColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(chooseTypeAction:)];
        [self addSubview:button];
        if (i != titleArray.count - 1) {
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width + button.frame.origin.x, 0, 1, 40)];
            sepView.backgroundColor = kBackgroundColor;
            [self addSubview:sepView];
            
        }
        
        CGRect bgViewFrame;
        bgViewFrame.size = CGSizeMake(button.frame.size.width, 15);
        bgViewFrame.origin = CGPointMake(button.frame.origin.x, CGRectGetMaxY(button.frame));
        sepBgView = [[UIView alloc]initWithFrame:bgViewFrame];
        sepBgView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sepBgView];
        
        
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 15, KScreenWidth / titleArray.count, 15)];
    bgView.backgroundColor = KNaviColor;
    
    [self addSubview:bgView];
    self.selectBGView = bgView;
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * KScreenWidth / titleArray.count, frame.size.height - 15, KScreenWidth / titleArray.count, 15)];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:12.f];
        firstLabel.textColor = [UIColor whiteColor];
        firstLabel.tag = i + 100;
        [self addSubview:firstLabel];
    }
    
    UIView *sectionSepView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, KScreenWidth, .7)];
    sectionSepView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sectionSepView];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.text = titleArray[label.tag - 100];
        }
    }
    
}

- (void)chooseTypeAction:(UIButton *)sender {
    CGRect bgViewFrame = self.selectBGView.frame;
    bgViewFrame.origin.x = sender.frame.origin.x;
    self.selectBGView.frame = bgViewFrame;
    if (self.selectTypeBlock) {
        self.selectTypeBlock(sender);
    }
}

@end
