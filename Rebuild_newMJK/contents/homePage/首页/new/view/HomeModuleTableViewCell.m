//
//  HomeModuleTableViewCell.m
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import "HomeModuleTableViewCell.h"

#import "MJKManagerModuleModel.h"

#import "MJKManagerModuleViewController.h"


@implementation HomeModuleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setModuleArray:(NSArray *)moduleArray  {
    _moduleArray  = moduleArray;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat width = (KScreenWidth - 50) / 4;
    for (int i = 0; i < moduleArray.count; i++) {
        UIButton *button = [UIButton new];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10 + (i/ 4) * (width - 10));
            make.left.mas_equalTo(10 + (width + 10) * (i % 4));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width - 20);
            if (i == moduleArray.count - 1) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }
        }];
        
        MJKManagerModuleModel *model = moduleArray[i];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGFloat imageWith = button.imageView.image.size.width;
        CGFloat imageHeight = button.imageView.image.size.height;
        CGFloat labelWidth = button.titleLabel.intrinsicContentSize.width;
        CGFloat labelHeight = button.titleLabel.intrinsicContentSize.height;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWith, -imageHeight-20/2.0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-labelHeight-20 / 2.0, 0, 0, -labelWidth)];
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
             UIViewController *rootVC = [DBTools getSuperViewWithsubView:self.contentView];
            if ([button.titleLabel.text isEqual:@"更多应用"]) {
                [rootVC.navigationController pushViewController:[MJKManagerModuleViewController new] animated:YES];
            } else {
                
                [DBObjectTools pushVCWithName:button.titleLabel.text andSelf:rootVC];
            }
        }];
        
    }
}

@end
