//
//  MJKGroupReportDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKLouDouDetailTableViewCell.h"
#import "MJKLouDouDetailModel.h"

@interface MJKLouDouDetailTableViewCell ()
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *labelArray;
/** <#注释#> */
@property (nonatomic, strong) NSArray *codeArray;
@end

@implementation MJKLouDouDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i =0; i < 2; i++) {
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i * (KScreenWidth / 2));
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(KScreenWidth / 2);
                make.height.mas_equalTo(40);
            }];
            
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.tag = 100 + i;
            label.textAlignment = NSTextAlignmentCenter;
            [self.labelArray addObject:label];
            
            UIView *sepView = [UIView new];
            [self.contentView addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
                make.left.equalTo(label).offset(-1);
            }];
            sepView.backgroundColor = kBackgroundColor;
        }
        
        UIView *sepBottomView = [UIView new];
        [self.contentView addSubview:sepBottomView];
        [sepBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-1);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        sepBottomView.backgroundColor = kBackgroundColor;
    }
    return self;
}

- (void)setModel:(MJKLouDouDetailModel *)model {
    _model = model;
    NSDictionary *dic = [model mj_keyValues];
    for (int i = 0; i < self.labelArray.count; i++) {
        UILabel *label = self.labelArray[i];
        for (NSDictionary *indexDic in self.codeArray) {
            if ([indexDic[@"index"] integerValue] == label.tag - 100) {
                label.text = dic[indexDic[@"content"]];
            }
        }
        if ([self.tableType isEqualToString:@"0"] || [self.tableType isEqualToString:@"1"]) {
            if (i == 0) {
                UIButton *toButton = [UIButton new];
                [self.contentView addSubview:toButton];
                [toButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.equalTo(label);
                }];
                self.toButton = toButton;
                label.textColor = [UIColor colorWithHexString:@"#1296db"];
                if ([label.text isEqualToString:@"合计"]) {
                    if (self.toButton) {
                        [self.toButton removeFromSuperview];
                    }
                    label.textColor = [UIColor blackColor];
                }
            }
        } else {
            if (self.toButton) {
                [self.toButton removeFromSuperview];
            }
            label.textColor = [UIColor blackColor];
        }
    }
    
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (NSArray *)codeArray {
    if (!_codeArray) {
//        _codeArray = @[@{@"index": @"0", @"content": @"name"},
//                       @{@"index": @"1", @"content": @"qyll"},
//                       @{@"index": @"2", @"content": @"yxkh"},
//                       @{@"index": @"3", @"content": @"daodian"},
//                       @{@"index": @"4", @"content": @"dingdan"},
//                       @{@"index": @"5", @"content": @"qk"},
//                       @{@"index": @"6", @"content": @"jf"}];
        _codeArray = @[@{@"index": @"0", @"content": @"name"},
                       @{@"index": @"1", @"content": @"total"}];
    }
    return _codeArray;
}

@end
