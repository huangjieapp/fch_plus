//
//  SJTableViewCell.m
//  SJVideoPlayer
//
//  Created by 畅三江 on 2018/9/30.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "SJTableViewCell.h"
#import <Masonry/Masonry.h>

#import "CGCExpandModel.h"

@interface SJTableViewCell ()
/** headImageView*/
@property (nonatomic, strong) UIImageView *headImageView;
/** nameLabel*/
@property (nonatomic, strong) UILabel *nameLabel;
/** desLabel*/
@property (nonatomic, strong) UILabel *desLabel;
/** <#注释#>*/
@property (nonatomic, strong) UIView *videoView;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *timeLabel;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation SJTableViewCell
+ (SJTableViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *SJTableViewCellID = @"SJTableViewCell";
    SJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTableViewCellID];
    if ( !cell ) {
        cell = [[SJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SJTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( !self ) return nil;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    _headImageView.layer.cornerRadius = 5.f;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 10, KScreenWidth - (2 * CGRectGetMaxX(_headImageView.frame) + 10), 20)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:self.nameLabel];
    
    self.desLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(self.nameLabel.frame) + 5, KScreenWidth - (2 * CGRectGetMaxX(_headImageView.frame) + 10), 20)];
    self.desLabel.textColor = [UIColor blackColor];
    self.desLabel.font = [UIFont systemFontOfSize:14.f];
    self.desLabel.numberOfLines = 0;
    [self.contentView addSubview:self.desLabel];
    
   self.videoView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(_headImageView.frame) + 10, KScreenWidth - (2 * CGRectGetMaxX(_headImageView.frame) + 10), KScreenWidth - (2 * CGRectGetMaxX(_headImageView.frame) + 10))];
    self.videoView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.videoView];
    
    
    
    _view = [SJPlayView new];
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _view.frame = self.videoView.bounds;
    [self.videoView addSubview:_view];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(self.videoView.frame) + 5, 100, 20)];
    self.addressLabel.textColor = [UIColor grayColor];
    self.addressLabel.font = [UIFont systemFontOfSize:12.f];
    self.addressLabel.textColor = [UIColor colorWithHex:@"#3E5687"];
    //    timeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.addressLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(self.addressLabel.frame) + 5, 100, 20)];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    //    timeLabel.numberOfLines = 0;
    [self.contentView addSubview:self.timeLabel];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(KScreenWidth - 50, self.timeLabel.frame.origin.y , 40, 20);
    [self.shareButton setImage:@"icon_material_more"];
    [self.contentView addSubview:self.shareButton];
    
    return self;
}

- (void)setModel:(CGCExpandModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture]];
//    self.view.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.poster]];
    self.nameLabel.text = model.salesname;
    self.desLabel.text = model.content;
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(KScreenWidth - 60 - 60, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    CGRect desLabelFrame = self.desLabel.frame;
    desLabelFrame.size.height = size.height;
    self.desLabel.frame = desLabelFrame;
    
    CGRect videoFrame = self.videoView.frame;
    videoFrame.origin.y = CGRectGetMaxY(self.desLabel.frame) + 10;
    self.videoView.frame = videoFrame;
    
    self.addressLabel.text = model.addressName;
    CGRect addressFrame = self.addressLabel.frame;
    addressFrame.origin.y = CGRectGetMaxY(self.videoView.frame) + 5;
    if (model.addressName.length > 0) {
        addressFrame.size.height = 30;
    } else {
        addressFrame.size.height = 0;
    }
    self.addressLabel.frame = addressFrame;
    
    self.timeLabel.text = model.time;
    CGRect timeFrame = self.timeLabel.frame;
    if (model.addressName.length > 0) {
        timeFrame.origin.y = CGRectGetMaxY(self.addressLabel.frame) + 5;
    } else {
        timeFrame.origin.y = CGRectGetMaxY(self.videoView.frame) + 5;
    }
    self.timeLabel.frame = timeFrame;
    
    CGRect shareFrame = self.shareButton.frame;
    shareFrame.origin.y =self.timeLabel.frame.origin.y ;
    self.shareButton.frame = shareFrame;
    
   
}

+ (CGFloat)cellHeight:(CGCExpandModel *)model {
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(KScreenWidth - 60 - 60, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    
    return KScreenWidth - 120  + 40 + size.height + 50 + (model.addressName.length > 0 ? 30 : 0);
}

@end
