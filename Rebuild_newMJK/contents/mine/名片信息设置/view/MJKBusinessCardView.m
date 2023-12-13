//
//  MJKBusinessCardView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/6/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessCardView.h"

@interface MJKBusinessCardView ()
@property (weak, nonatomic) IBOutlet UIImageView *normalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation MJKBusinessCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar]];
    self.nameLabel.text = [NewUserSession instance].user.nickName;
    self.positionLabel.text = [NewUserSession instance].C_XCXPOSITION;
    self.phoneLabel.text = [NewUserSession instance].user.phonenumber;
    self.secondLabel.text = [NewUserSession instance].C_ABBREVATION;
    self.addressLabel.text = [NewUserSession instance].storeAddress;
    self.normalImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.normalImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].BusinessCardPicture] placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://cdn.51mcr.com/FoVw8reP1arPOUZ-begbKlENS6tZ"]]]];
}

- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
}

- (void)setPositionStr:(NSString *)positionStr {
    _positionStr = positionStr;
    self.positionLabel.text = positionStr;
}

- (void)setPhoneStr:(NSString *)phoneStr {
    _phoneStr = phoneStr;
    self.phoneLabel.text = phoneStr;
}

- (void)setSecondStr:(NSString *)secondStr {
    _secondStr = secondStr;
    self.secondLabel.text = secondStr;
}

- (void)setAddressStr:(NSString *)addressStr {
    _addressStr = addressStr;
    self.addressLabel.text = addressStr;
}

@end
