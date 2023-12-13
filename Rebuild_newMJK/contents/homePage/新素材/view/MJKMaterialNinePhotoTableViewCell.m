//
//  MJKMaterialListType0TableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialNinePhotoTableViewCell.h"
#import "MJKMaterialListModel.h"

@interface MJKMaterialNinePhotoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation MJKMaterialNinePhotoTableViewCell

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
   
    CGFloat imageViewWidth = (KScreenWidth - 20 - 20) / 3;
    for (int i = 0; i < (model.images.count >= 9 ? 9 : model.images.count); i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i % 3 * 10) + (i % 3) * imageViewWidth  , (i / 3 * 10) + (i / 3) * imageViewWidth, imageViewWidth, imageViewWidth)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage scaledImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.images[i]]] withSize:CGSizeMake(KScreenWidth/2, KScreenWidth/2) scale:.9f orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        });
        [self.detailView addSubview:imageView];
    }
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    if (self.shareButtonActionBlock) {
        self.shareButtonActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMaterialNinePhotoTableViewCell";
    MJKMaterialNinePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

+ (CGFloat)heightForCellWithModel:(MJKMaterialListModel *)model {
    CGFloat imageViewWidth = (KScreenWidth - 20 - 20) / 3;
    return (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * imageViewWidth + (model.images.count % 3 != 0 ? (model.images.count / 3) + 1 : (model.images.count / 3)) * 20;
}

- (void)dealloc {
    MyLog(@"%s", __func__);
}

@end
