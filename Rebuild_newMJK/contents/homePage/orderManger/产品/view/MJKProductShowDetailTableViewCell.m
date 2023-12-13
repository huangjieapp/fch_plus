//
//  MJKProductShowDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/3.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKProductShowDetailTableViewCell.h"
#import "MJKProductShowModel.h"

#import "AddOrEditlCustomerViewController.h"
#import "MJKClueAddViewController.h"
#import "MJKClueDetailViewController.h"

@interface MJKProductShowDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MJKProductShowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKProductShowModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.X_FMPICURL]];
    if (self.isNoPrice == YES) {
        self.nameLabel.text = model.C_NAME;
    } else {
        self.nameLabel.text = model.X_REMARK;
    }
    
    self.priceLabel.hidden = self.isNoPrice;
    self.countLabel.hidden = YES;
    //    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",model.B_HDJ.integerValue];
    self.countLabel.text = [NSString stringWithFormat:@"x %ld",(long)model.number];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKProductShowDetailTableViewCell";
    MJKProductShowDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

@end
