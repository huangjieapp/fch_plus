//
//  MJKFlowMeterListCollectionViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterListCollectionViewCell.h"
#import <sys/utsname.h>


@implementation MJKFlowMeterListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	NSString *type = [self iphoneType];
	if ([type isEqualToString:@"iPhone 5"] || [type isEqualToString:@"iPhone 5c"] || [type isEqualToString:@"iPhone 5s"] || [type isEqualToString:@"iPhone Simulator"]) {
		self.timeLabel.font = self.statusLabel.font = [UIFont systemFontOfSize:11.0f];
	}
}

- (void)setModel:(MJKFlowMeterSubSecondModel *)model {
	_model = model;
	//加载图片有延迟，用多线程
//	dispatch_async(dispatch_get_global_queue(0, 0), ^{
//		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.C_HEADPIC]];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			self.headImageView.image = [UIImage imageWithData:data];
//		});
//	});
    if (model.guijiflag.boolValue == YES) {
        self.arraiveInfoImageView.hidden = NO;
    } else {
        self.arraiveInfoImageView.hidden = YES;
    }
    
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADPIC]];
	NSString *timeArrivalShop = [model.D_ARRIVAL_TIME substringWithRange:NSMakeRange(11, 8)];
	//如果跟客户没有关系，就显示状态：未留档，黑名单，员工，无效。
//	if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0005"]) {
//		self.timeLabel.text = timeArrivalShop;
        self.statusLabel.hidden = NO;
//		self.statusLabel.textColor = [UIColor blackColor];
//		self.staffImageView.hidden = NO;
		self.staffImageView.image = [UIImage imageNamed:@"flow_finis.png"];
//		self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//
//		count0000 = 0;
//		self.chooseMoreImage.image = [UIImage imageNamed:@""];
//		if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"]) {
//			self.statusLabel.text = @"黑名单";
//		} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"]) {
//			self.statusLabel.text = @"员工";
//		} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"]) {
//			self.statusLabel.text = @"无效";
//		} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0005"]) {
//			self.statusLabel.text = @"未留档";
//		} else {
//			self.statusLabel.text = @"";
//		}
//	} else {
    
    
		if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
			self.staffImageView.hidden = YES;
			if (self.isMore == YES) {
				self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = NO;
				self.chooseMoreImage.image = model.isSelected == YES ? [UIImage imageNamed:@"打钩.png"] : [UIImage imageNamed:@"未打钩.png"];
	
	//			[self.chooseMoreButton setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
			} else {
				count0000 = 0;
				self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
				self.chooseMoreImage.image = [UIImage imageNamed:@""];
	//			[self.chooseMoreButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
			}
			self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeArrivalShop,model.C_SALENAME.length > 0 ? model.C_SALENAME : @"--"];
            self.statusLabel.text = [NSString stringWithFormat:@"%@次到店/%@",model.I_ARRIVAL,model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @"--"];
		} else {
			count0000 = 0;
			self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
			self.chooseMoreImage.image = [UIImage imageNamed:@""];
			if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0005"] || [model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0008"]) {
				NSString *statusStr;
				if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"]) {
					statusStr = @"黑名单";
				} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"]) {
					statusStr = @"员工";
				} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"]) {
					statusStr = @"无效";
				} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0005"]) {
					statusStr = @"未留档";
				} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0008"]) {
					statusStr = @"已指派";
				}
				else {
					statusStr = @"--";
				}

//                self.timeLabel.text = [NSString stringWithFormat:@"%@/%@\n%@次到店/%@",timeArrivalShop,model.USERNAME.length > 0 ? model.USERNAME : @"--",model.I_ARRIVAL,model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : statusStr];
                self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeArrivalShop,model.USERNAME.length > 0 ? model.USERNAME : @"--"];
                self.statusLabel.text = [NSString stringWithFormat:@"%@次到店/%@",model.I_ARRIVAL,model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : statusStr];
			} else {
//                self.timeLabel.text = [NSString stringWithFormat:@"%@/%@\n%@次到店/%@",timeArrivalShop,model.USERNAME.length > 0 ? model.USERNAME : @"--",model.I_ARRIVAL,model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @"--"];
                self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeArrivalShop,model.USERNAME.length > 0 ? model.USERNAME : @"--"];
                self.statusLabel.text = [NSString stringWithFormat:@"%@次到店/%@",model.I_ARRIVAL,model.C_A41500_C_NAME.length > 0 ? model.C_A41500_C_NAME : @"--"];
			}
			
//			self.statusLabel.hidden = YES;
			self.staffImageView.hidden = NO;
//			self.staffImageView.image = [UIImage imageNamed:@""];
		}
	
//	}
	
	if ([model.LEVEL isEqualToString:@"VIP"]) {
		self.statusImageView.hidden = NO;
		self.statusImageView.image = [UIImage imageNamed:@"flow_vip.png"];
	} else if ([model.LEVEL isEqualToString:@"HEART"]) {
		self.statusImageView.hidden = NO;
		self.statusImageView.image = [UIImage imageNamed:@"flow_love.png"];
	} else {
		self.statusImageView.hidden = YES;
	}
	
//	if ([model.I_ARRIVAL isEqualToString:@"4"] || [model.I_ARRIVAL isEqualToString:@"5"]) {
//		self.statusImageView.hidden = NO;
//		self.statusImageView.image = [UIImage imageNamed:@"flow_love.png"];
//	} else if ([model.I_ARRIVAL isEqualToString:@"6"] || [model.I_ARRIVAL isEqualToString:@"7"]) {
//		self.statusImageView.hidden = NO;
//		self.statusImageView.image = [UIImage imageNamed:@"flow_vip.png"];
//	}else {
//		self.statusImageView.hidden = YES;
//	}
//	if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0004"]) {
//		self.staffImageView.image = [UIImage imageNamed:@"flow_finis.png"];
//		self.statusLabel.text = @"黑名单";
//		self.statusLabel.textColor = [UIColor blackColor];
//		self.staffImageView.hidden = NO;
//
//		self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//	} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0003"]) {
//		self.staffImageView.image = [UIImage imageNamed:@"flow_finis.png"];
//		self.statusLabel.text = @"已处理";
//		self.statusLabel.textColor = [UIColor blackColor];
//		self.staffImageView.hidden = NO;
//		self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//	} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0002"]) {
//		self.staffImageView.hidden = YES;
//		self.statusLabel.textColor = [UIColor redColor];
//		self.statusLabel.text = @"未处理";
//		if (self.isMore == YES) {
//			self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = NO;
//			self.chooseMoreImage.image = model.isSelected == YES ? [UIImage imageNamed:@"打钩.png"] : [UIImage imageNamed:@"未打钩.png"];
//
////			[self.chooseMoreButton setBackgroundImage:[UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
//		} else {
//			count0000 = 0;
//			self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//			self.chooseMoreImage.image = [UIImage imageNamed:@""];
////			[self.chooseMoreButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//		}
//	} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0001"]) {
//		self.staffImageView.image = [UIImage imageNamed:@"flow_finis.png"];
//		self.statusLabel.text = @"员工";
//		self.statusLabel.textColor = [UIColor blackColor];
//		self.staffImageView.hidden = NO;
//		self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//	} else if ([model.C_ARRIVAL_DD_ID isEqualToString:@"A46000_C_STATUS_0000"]) {
//		self.staffImageView.image = [UIImage imageNamed:@"flow_finis.png"];
//		self.statusLabel.text = @"无效";
//		self.statusLabel.textColor = [UIColor blackColor];
//		self.staffImageView.hidden = NO;
//		self.chooseMoreButton.hidden = self.chooseMoreImage.hidden = YES;
//	}
	
}
static int count0000 = 0;
- (IBAction)chooseMoreButtonAction:(UIButton *)sender {
	self.model.selected = !self.model.isSelected;
    if (self.model.isSelected == NO) {
        count0000--;
    } else {
		if (count0000 >= 6) {
			[JRToast showWithText:@"最多可选六个"];
			self.model.selected = NO;
			return;
		}
        count0000++;
    }
	self.chooseMoreImage.image = self.model.isSelected == YES ? [UIImage imageNamed:@"打钩.png"] : [UIImage imageNamed:@"未打钩.png"];
//	[sender setBackgroundImage:self.model.isSelected == YES ? [UIImage imageNamed:@"打钩.png"] : [UIImage imageNamed:@"未打钩.png"] forState:UIControlStateNormal];
    
	if (self.chooseMoreBlock) {
        self.chooseMoreBlock(self.model);
	}
}

+ (instancetype)cellWithTableView:(UICollectionView *)tableView andIndexPath:(NSIndexPath *)indexPath {
	static NSString *ID = @"MJKFlowMeterListCollectionViewCell";
	MJKFlowMeterListCollectionViewCell *cell = [tableView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
	}
	return cell;
	
}

- (NSString *)iphoneType {
	
	//需要导入头文件：#import <sys/utsname.h>
	
	struct utsname systemInfo;
	
	uname(&systemInfo);
	
	NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
	
	if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
	
	if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	
	if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
	
	if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
	
	if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
	
	if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
	
	if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
	
	if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
	
	if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
	
	if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
	
	if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
	
	if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
	
	if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
	
	if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
	
	if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
	
	if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
	
	if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
	
	if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
	
	if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
	
	if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
	
	if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
	
	if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
	
	if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
	
	if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
	
	if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
	
	if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
	
	if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
	
	if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
	
	if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
	
	if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
	
	if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
	
	if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
	
	if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
	
	if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
	
	if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
	
	if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
	
	if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
	
	if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
	
	if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
	
	return platform;
	
}

@end
