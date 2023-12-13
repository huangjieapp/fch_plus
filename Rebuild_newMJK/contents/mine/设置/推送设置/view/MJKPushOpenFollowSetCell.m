//
//  MJKPushOpenFollowSetCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenFollowSetCell.h"
#import "MJKCustomReturnSubModel.h"

#import "DBPickerView.h"

@interface MJKPushOpenFollowSetCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
/** row*/
@property (nonatomic, assign) NSInteger row;
/** MJKCustomReturnSubModel*/
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
/** typeNumber*/
@property (nonatomic, strong) NSString *typeNumber;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;
@end

@implementation MJKPushOpenFollowSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithModel:(MJKCustomReturnSubModel *)model andRow:(NSInteger)row andTypeNumber:(NSString *)typeNumber {
    self.openButton.hidden = YES;
	self.model = model;
	self.row = row;
	self.typeNumber = typeNumber;
	if ([typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
		self.titleLabel.text = @"推送时间";
		if (model.C_FIRSTPUSH.length > 0) {
			self.timeLabel.hidden = NO;
			self.timeLabel.text = model.C_FIRSTPUSH;
			[self.openButton setBackgroundColor:KNaviColor];
			[self.openButton setTitleNormal:@"关闭"];
			self.openButton.selected = YES;
            self.openSwitchButton.on = YES;
		} else {
			self.timeLabel.hidden = YES;
			[self.openButton setBackgroundColor:kBackgroundColor];
			[self.openButton setTitleNormal:@"开启"];
			self.openButton.selected = NO;
            self.openSwitchButton.on = NO;
		}
	} else {
	if (row == 0) {
		self.titleLabel.text = @"第一次推送时间";
		if (model.C_FIRSTPUSH.length > 0) {
			self.timeLabel.hidden = NO;
			self.timeLabel.text = model.C_FIRSTPUSH;
			[self.openButton setBackgroundColor:KNaviColor];
			[self.openButton setTitleNormal:@"关闭"];
			self.openButton.selected = YES;
            self.openSwitchButton.on = YES;
		} else {
			self.timeLabel.hidden = YES;
			[self.openButton setBackgroundColor:kBackgroundColor];
			[self.openButton setTitleNormal:@"开启"];
			self.openButton.selected = NO;
            self.openSwitchButton.on = NO;
		}
	} else if (row == 1) {
		self.titleLabel.text = @"第二次推送时间";
		if (model.C_SECONDPUSH.length > 0) {
			self.timeLabel.hidden = NO;
			self.timeLabel.text = model.C_SECONDPUSH;
			[self.openButton setBackgroundColor:KNaviColor];
			[self.openButton setTitleNormal:@"关闭"];
			self.openButton.selected = YES;
            self.openSwitchButton.on = YES;
		} else {
			self.timeLabel.hidden = YES;
			[self.openButton setBackgroundColor:kBackgroundColor];
			[self.openButton setTitleNormal:@"开启"];
			self.openButton.selected = NO;
            self.openSwitchButton.on = NO;
		}
	} else {
		self.titleLabel.text = @"第三次推送时间";
		if (model.C_THIRDPUSH.length > 0) {
			self.timeLabel.hidden = NO;
			self.timeLabel.text = model.C_THIRDPUSH;
			[self.openButton setBackgroundColor:KNaviColor];
			[self.openButton setTitleNormal:@"关闭"];
			self.openButton.selected = YES;
            self.openSwitchButton.on = YES;
		} else {
			self.timeLabel.hidden = YES;
			[self.openButton setBackgroundColor:kBackgroundColor];
			[self.openButton setTitleNormal:@"开启"];
			self.openButton.selected = NO;
            self.openSwitchButton.on = NO;
		}
	}
	}
}
- (IBAction)openSwitchAction:(UISwitch *)sender {
    DBSelf(weakSelf);
//    sender.on = !sender.isOn;
    NSMutableArray *timeArray = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            [timeArray addObject:[NSString stringWithFormat:@"0%d",i]];;
        } else {
            [timeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    if (sender.isOn == YES) {
        DBPickerView *pickView = [[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:timeArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
            weakSelf.timeLabel.hidden = NO;
            NSString *timesStr = [NSString stringWithFormat:@"%@:00",title];
            if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
                weakSelf.model.C_FIRSTPUSH = timesStr ;
                weakSelf.timeLabel.text = timesStr;
            } else {
                if (self.row == 0) {
                    weakSelf.model.C_FIRSTPUSH = timesStr;
                    weakSelf.timeLabel.text = timesStr;
                } else if (self.row == 1) {
                    weakSelf.model.C_SECONDPUSH = timesStr;
                    weakSelf.timeLabel.text = timesStr;
                } else {
                    weakSelf.model.C_THIRDPUSH = timesStr;
                    weakSelf.timeLabel.text = timesStr;
                }
            }
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:pickView];
    } else {
        self.timeLabel.hidden = YES;
        if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
            weakSelf.model.C_FIRSTPUSH = @"";
            weakSelf.timeLabel.text = @"";
        } else {
            
            
            if (self.row == 0) {
                weakSelf.model.C_FIRSTPUSH = @"";
                weakSelf.timeLabel.text = @"";
            } else if (self.row == 1) {
                weakSelf.model.C_SECONDPUSH = @"";
                weakSelf.timeLabel.text = @"";
            } else {
                weakSelf.model.C_THIRDPUSH = @"";
                weakSelf.timeLabel.text = @"";
            }
        }
    }
    
}

- (IBAction)openButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
	sender.selected = !sender.isSelected;
	[sender setBackgroundColor:sender.isSelected == YES ? KNaviColor : kBackgroundColor ];
	[sender setTitleNormal:sender.isSelected == YES ? @"关闭" : @"开启"];
	NSMutableArray *timeArray = [NSMutableArray array];
	for (int i = 0; i < 24; i++) {
		if (i < 10) {
			[timeArray addObject:[NSString stringWithFormat:@"0%d",i]];;
		} else {
			[timeArray addObject:[NSString stringWithFormat:@"%d",i]];
		}
	}
	if (sender.isSelected == YES) {
		DBPickerView *pickView = [[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:timeArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
			weakSelf.timeLabel.hidden = NO;
			NSString *timesStr = [NSString stringWithFormat:@"%@:00",title];
			if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
				weakSelf.model.C_FIRSTPUSH = timesStr ;
				weakSelf.timeLabel.text = timesStr;
			} else {
			if (self.row == 0) {
				weakSelf.model.C_FIRSTPUSH = timesStr;
				weakSelf.timeLabel.text = timesStr;
			} else if (self.row == 1) {
				weakSelf.model.C_SECONDPUSH = timesStr;
				weakSelf.timeLabel.text = timesStr;
			} else {
				weakSelf.model.C_THIRDPUSH = timesStr;
				weakSelf.timeLabel.text = timesStr;
			}
			}
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:pickView];
	} else {
		self.timeLabel.hidden = YES;
		if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
			weakSelf.model.C_FIRSTPUSH = @"";
			weakSelf.timeLabel.text = @"";
		} else {
			
		
		if (self.row == 0) {
			weakSelf.model.C_FIRSTPUSH = @"";
			weakSelf.timeLabel.text = @"";
		} else if (self.row == 1) {
			weakSelf.model.C_SECONDPUSH = @"";
			weakSelf.timeLabel.text = @"";
		} else {
			weakSelf.model.C_THIRDPUSH = @"";
			weakSelf.timeLabel.text = @"";
		}
		}
	}
	
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKPushOpenFollowSetCell";
	MJKPushOpenFollowSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
