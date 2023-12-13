//
//  MJKTitleTabView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTitleTabView.h"

@interface MJKTitleTabView ()
/** sepView*/
@property (nonatomic, strong) UIView *sepView;
/** <#注释#>*/
@property (nonatomic, assign)  BOOL canChoose;
@end

@implementation MJKTitleTabView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray andIsCanChooseTab:(BOOL)canChoose isSepView:(BOOL)isSep {
    if (self = [super initWithFrame:frame]) {
        [self configUIWithFrame:frame withTitleArray:titleArray andIsCanChooseTab:canChoose isSepView:isSep];
    }
    return self;
}

- (void)configUIWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray andIsCanChooseTab:(BOOL)canChoose  isSepView:(BOOL)isSep {
    self.canChoose = canChoose;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.tag = 100;
    [self addSubview:bgView];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (bgView.frame.size.width / titleArray.count), 0, bgView.frame.size.width / titleArray.count, bgView.frame.size.height - 2)];
        [button setTitleNormal:titleArray[i]];
        [button setTitleColor:[UIColor blackColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [button addTarget:self action:@selector(chooseTabAction:)];
        [bgView addSubview:button];
        if (canChoose == YES) {
            if (i == 0) {
                [button setTitleColor:KNaviColor];
            }
        }
        if (i != 0 || i != titleArray.count - 1) {
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, 5, 1, button.frame.size.height - 10)];
            sepView.backgroundColor = DBColor(224,224,224);
            if (isSep == YES) {
                [bgView addSubview:sepView];
            }
        }
    }
    
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height - 2, bgView.frame.size.width / titleArray.count, 2)];
    sepView.backgroundColor = KNaviColor;
    sepView.tag = 101;
    if (canChoose == YES) {
        [bgView addSubview:sepView];
    }
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-1, KScreenWidth, 1)];
    bottomView.backgroundColor = DBColor(224,224,224);
    if (isSep == YES) {
        [bgView addSubview:bottomView];
    }
    
    self.sepView = sepView;
    
}

- (void)chooseTabAction:(UIButton *)sender {
    if (self.canChoose == YES) {
        for (UIView *view in self.subviews) {
            if (view.tag == 100) {
                for (UIView *subView in view.subviews) {
                    if ([subView isKindOfClass:[UIButton class]]) {
                        //只有按钮文字匹配才能选中，否则都是不选中的黑色
                        UIButton *button = (UIButton *)subView;
                        if ([button.titleLabel.text isEqualToString:sender.titleLabel.text]) {
                            [sender setTitleColor:KNaviColor];
                        } else {
                            [button setTitleColor:[UIColor blackColor]];
                        }
                    }
                }
            }
        }
        CGRect frame = self.sepView.frame;
        frame.origin.x = sender.frame.origin.x;
        self.sepView.frame = frame;
    }
    
    if (self.chooseTabBlock) {
        self.chooseTabBlock(sender.titleLabel.text);
    }
}

- (void)setSelectButtonTitle:(NSString *)selectButtonTitle {
    _selectButtonTitle = selectButtonTitle;
    for (UIView *view in self.subviews) {
        if (view.tag == 100) {
             for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    //只有按钮文字匹配才能选中，否则都是不选中的黑色
                    UIButton *button = (UIButton *)subView;
                    if ([button.titleLabel.text isEqualToString:selectButtonTitle]) {
                        [button setTitleColor:KNaviColor];
                        CGRect frame = self.sepView.frame;
                        frame.origin.x = button.frame.origin.x;
                        self.sepView.frame = frame;
                    } else {
                        [button setTitleColor:[UIColor blackColor]];
                    }
                    
                }
                 
            }
            
        
        }
    }
}

@end
