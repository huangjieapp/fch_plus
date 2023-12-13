//
//  CGCCustomCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCCustomModel;
@class PointorderModel;
typedef enum : NSUInteger {
    CGCCustomCellNormal,
    CGCCustomCellSel
} CGCCustomCellType;

@interface CGCCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *iconLab;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *AImg;
@property (weak, nonatomic) IBOutlet UIImageView *starImg;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *sellNameLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingWidth;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *cusName;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithType:(CGCCustomCellType)cellType withModel:(CGCCustomModel *)model;

-(void)verificationCellReloadCell:(PointorderModel *)model;

-(void)brokerCellWithModel:(CGCCustomModel *)model;

@end
