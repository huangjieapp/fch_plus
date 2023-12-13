//
//  MJKSocialPresonShareTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/3.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKSocialPresonShareTableViewCell.h"
#import "MJKSocialPresonShareModel.h"

@implementation MJKSocialPresonShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSocialPresonShareModel *)model {
    _model = model;
    DBSelf(weakSelf);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture] placeholderImage:[UIImage imageNamed:@"logo-2"]];
    self.nameLabel.text = model.salesname;
    self.contentLabel.text = model.title;
    self.timeLabel.text = model.showTime;
    self.showLabel.text = [NSString stringWithFormat:@"%@人浏览",model.readNumber];
    for (int i = 0; i < model.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i % 3) * (10 + (KScreenWidth - 100) / 3),(i / 3) * (10 + (KScreenWidth - 100) / 3), (KScreenWidth - 100) / 3, (KScreenWidth - 100) / 3)];
        if (i % 3 == 0 && i != 0) {
            self.detailViewWidthLayout.constant += (10 + (KScreenWidth - 100) / 3);
        }
//        self.detailViewWidthLayout.constant += (i / 3) * (10 + (KScreenWidth - 100) / 3);
        [self.detailView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    weakSelf.detailViewWidthLayout.constant = image.size.height / (image.size.width / ((KScreenWidth - 100) / model.images.count));
//                    imageView.frame = CGRectMake(i * (10 + (KScreenWidth - 100) / model.images.count), 0, (KScreenWidth - 100) / model.images.count, weakSelf.detailViewWidthLayout.constant);
                });
            }];
        
    }
    
    
    
}

+ (CGFloat)cellForHeight:(MJKSocialPresonShareModel *)model {
    CGFloat height = (10 + (KScreenWidth - 100) / 3) + 90;
    for (int i = 0; i < model.images.count; i++) {
        if (i % 3 == 0 && i != 0) {
            height += (10 + (KScreenWidth - 100) / 3);
        }
            
    }
    if (model.title.length > 0) {
        CGFloat titleHeight = [model.title boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        height += titleHeight + 20;
    }
    return height;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSocialPresonShareTableViewCell";
    MJKSocialPresonShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}



@end
