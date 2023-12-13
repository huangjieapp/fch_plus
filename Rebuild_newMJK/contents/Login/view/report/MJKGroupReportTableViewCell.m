//
//  MJKGroupReportTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKGroupReportTableViewCell.h"

@implementation MJKGroupReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIScrollView *scrollView = [UIScrollView new];
        [self.contentView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        
        UIButton *backButton = [UIButton new];
        [self.contentView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(50);
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(90);
            make.bottom.mas_equalTo(-5);
        }];
        [backButton setTitle:@"返回上一层" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor colorWithHex:@"#777777"] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        backButton.layer.borderColor = kBackgroundColor.CGColor;
        backButton.layer.borderWidth = 1.f;
        backButton.layer.cornerRadius = 5.f;
        backButton.hidden = YES;
        self.backButton = backButton;
        
        UILabel *leftLabel = [UILabel new];
        [scrollView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(scrollView);
        }];
        
        leftLabel.text = @"归属年月";
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont boldSystemFontOfSize:14.f];
        
        
        
        UIView *view = [UIView new];
        [scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right).offset(15);
            make.centerY.equalTo(scrollView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(88);
        }];
        view.layer.borderColor = kBackgroundColor.CGColor;
        view.layer.borderWidth = 1.f;
        view.layer.cornerRadius = 5.f;
        
        UIImageView *imageView = [UIImageView new];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(view);
            make.width.height.mas_equalTo(10);
        }];
        imageView.image = [UIImage imageNamed:@"操作日历"];
        
        UILabel *timeLabel = [UILabel new];
        [view addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(view);
            make.right.mas_equalTo(-5);
        }];
        timeLabel.text = @"2022-12";
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:14.f];
        self.timeLabel = timeLabel;
        
        UIButton *timeButton = [UIButton new];
        [view addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        self.timeButton = timeButton;
        
        UILabel *centerLabel = [UILabel new];
        [scrollView addSubview:centerLabel];
        [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right).offset(15);
            make.centerY.equalTo(scrollView);
        }];
        
        centerLabel.text = @"数据视角";
        centerLabel.textColor = [UIColor blackColor];
        centerLabel.font = [UIFont boldSystemFontOfSize:14.f];
        
        
        UIButton *leftButton = [UIButton new];
        [scrollView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerLabel.mas_right).offset(15);
            make.centerY.equalTo(scrollView);
        }];
        [leftButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"guifandanxuanxuanzhong"] forState:UIControlStateSelected];
        [leftButton setTitle:@"按层级" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateSelected];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        leftButton.selected = YES;
        self.leftButton = leftButton;
        
        
        UIButton *rightButton = [UIButton new];
        [scrollView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftButton.mas_right).offset(15);
            make.centerY.equalTo(scrollView);
        }];
        [rightButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"guifandanxuanxuanzhong"] forState:UIControlStateSelected];
        [rightButton setTitle:@"按门店" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateSelected];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.rightButton = rightButton;
        
        
        scrollView.contentSize = CGSizeMake(430, 50);
        scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return self;
}



@end
