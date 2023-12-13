//
//  MJKMaterialListType0TableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialListType0TableViewCell.h"
#import "MJKMaterialListModel.h"

@interface MJKMaterialListType0TableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightLayout;

@end

@implementation MJKMaterialListType0TableViewCell

static BOOL SDImageCacheOldShouldDecompressImages = YES;

static BOOL SDImagedownloderOldShouldDecompressImages = YES;

- (void)awakeFromNib {
    [super awakeFromNib];
//    SDImageCache *canche =[SDImageCache sharedImageCache];
//
//    SDImageCacheOldShouldDecompressImages = canche.config.shouldDecompressImages;
//
//    canche.config.shouldDecompressImages = NO;
//
//    SDWebImageDownloader *downloder =[SDWebImageDownloader sharedDownloader];
//
//    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
//
//    downloder.shouldDecompressImages = NO;
}

- (void)setModel:(MJKMaterialListModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture]];
    self.nameLabel.text = model.salesname;
    NSString *str = model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.contentLabel.text = str;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (height > 20) {
        self.contentLabelHeightLayout.constant = height + 10;
    }
    self.timeLabel.text = model.time;
    CGFloat imageViewWidth = (KScreenWidth - 20 - 20) / 3;
    for (int i = 0; i < (model.images.count >= 9 ? 9 : model.images.count); i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i % 3 * 10) + (i % 3) * imageViewWidth  , (i / 3 * 10) + (i / 3) * imageViewWidth, imageViewWidth, imageViewWidth)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.images[i]]] withSize:CGSizeMake(KScreenWidth / 2, KScreenWidth / 2) scale:.9f orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        });
        
        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
        [self.detailView addSubview:imageView];
    }
    self.detailViewHeightLayout.constant = (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * imageViewWidth + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * 20;
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    if (self.shareButtonActionBlock) {
        self.shareButtonActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMaterialListType0TableViewCell";
    MJKMaterialListType0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

+ (CGFloat)heightForCellWithModel:(MJKMaterialListModel *)model {
    NSString *str = model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    CGFloat imageViewWidth = (KScreenWidth - 20 - 20) / 3;
    if (height > 20) {
        return 75 + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * imageViewWidth + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * 20 + height;
    }
    return 95 + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * imageViewWidth + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * 20;
}

- (void)dealloc {
    MyLog(@"%s", __func__);
}

@end
