//
//  MJKFlowDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowDetailTableViewCell.h"

#import "DBPickerView.h"

#import "MJKFunnelChooseModel.h"

#import "MJKFlowDetailModel.h"

@interface MJKFlowDetailTableViewCell ()<UITextFieldDelegate, UITextViewDelegate>
/** MJKFlowDetailModel*/
@property (nonatomic, strong) MJKFlowDetailModel *flowModel;
@end

@implementation MJKFlowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCell:(NSArray *)titleArr andModel:(MJKFlowDetailModel *)model andRow:(NSInteger)row {
	self.titleLabel.text = titleArr[row];
//	self.phoneNumber.delegate = self;
//	self.flowModel = model;
	switch (row) {
		case 0:
			self.contentLabel.text = model.I_PEPOLE_NUMBER;
			break;
		case 1:
			self.contentLabel.text = model.C_CLUESOURCE_DD_NAME;
			break;
		case 2:
			self.contentLabel.text = model.D_ARRIVAL_TIME;
			break;
        case 3:
            self.contentLabel.text = model.C_SOURCE_DD_NAME;
//			self.type = ChooseTableViewTypeCustomerSource;
//			self.contentLabel.hidden = YES;
//			self.phoneNumber.hidden = NO;
//			self.phoneNumber.borderStyle = UITextBorderStyleNone;
//			if (model.C_STAYTIME_DD_NAME.length > 0) {
//				self.phoneNumber.text = model.C_SOURCE_DD_NAME;
//			} else {
//				self.phoneNumber.placeholder = @"请选择>";
//			}
            break;
		case 4:
//			self.type = ChooseTableViewTypeAction;
			self.contentLabel.text = model.C_A41200_C_NAME;
//			self.contentLabel.hidden = YES;
//			self.phoneNumber.hidden = NO;
//			self.phoneNumber.borderStyle = UITextBorderStyleNone;
//			if (model.C_STAYTIME_DD_NAME.length > 0) {
//				self.phoneNumber.text = model.C_A41200_C_NAME;
//			} else {
//				self.phoneNumber.placeholder = @"请选择>";
//			}
			break;
		case 5:
//			self.type = ChooseTableViewTypeStay;
			self.contentLabel.text = model.C_STAYTIME_DD_NAME;
//			self.contentLabel.hidden = YES;
//			self.phoneNumber.hidden = NO;
//			self.phoneNumber.borderStyle = UITextBorderStyleNone;
//			if (model.C_STAYTIME_DD_NAME.length > 0) {
//				self.phoneNumber.text = model.C_STAYTIME_DD_NAME;
//			} else {
//				self.phoneNumber.placeholder = @"请选择>";
//			}
			break;
		case 6: {
//			self.contentLabel.hidden = YES;
//			UITextView *textView = [[UITextView alloc]init];
//			[self.contentView addSubview:textView];
//			textView.delegate = self;
//			textView.font = [UIFont systemFontOfSize:13.f];
//			[textView mas_makeConstraints:^(MASConstraintMaker *make) {
//				make.left.mas_equalTo(130);
//				make.top.mas_equalTo(0);
//				make.bottom.mas_equalTo(0);
//				make.right.mas_equalTo(-20);
//			}];
//			textView.text = model.C_ATTENDANT;
			
			[self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.left.mas_equalTo(130);
				make.top.mas_equalTo(0);
				make.bottom.mas_equalTo(0);
			}];
			self.contentLabel.numberOfLines = 0;
			self.contentLabel.text = model.C_ATTENDANT;
			self.contentLabel.textAlignment = NSTextAlignmentRight;
		}
			break;
		default:
			break;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	DBSelf(weakSelf);
	textField.inputView = [[UIView alloc]init];
	if (self.type == ChooseTableViewTypeCustomerSource) {
		NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
		NSMutableArray*mtArray=[NSMutableArray array];
		NSMutableArray*postArray=[NSMutableArray array];
		for (MJKDataDicModel*model in dataArray) {
			[mtArray addObject:model.C_NAME];
			[postArray addObject:model.C_VOUCHERID];
		}
		
		DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:@"来源渠道" andBlock:^(NSString *title, NSString *indexStr) {
			MyLog(@"%@    %@",title,indexStr);
			NSInteger number=[indexStr integerValue];
			NSString*postStr=postArray[number];
			
//			if (self.chooseBlock) {
//				self.chooseBlock(title, postStr);
//			}
			textField.text = title;
			weakSelf.flowModel.C_SOURCE_DD_NAME =  title;
			weakSelf.flowModel.C_SOURCE_DD_ID = postStr;
			
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
	} else if (self.type == ChooseTableViewTypeAction) {
		[HttpWebObject HttpObjectGetMarketActionWithSourceID:weakSelf.flowModel.C_SOURCE_DD_ID Success:^(id data) {
			MyLog(@"%@",data);
			if ([data[@"code"] integerValue]==200) {
				NSMutableArray*mtArray=[NSMutableArray array];    //单单要的title
				NSMutableArray*saveMarketArray=[NSMutableArray array];  //保存model
				NSArray*array=data[@"data"][@"list"];
				for (NSDictionary*dict in array) {
					MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
					model.name=dict[@"C_NAME"];
					model.c_id=dict[@"C_ID"];
					
					[saveMarketArray addObject:model];
					[mtArray addObject:model.name];
				}
				if (mtArray.count <= 0) {
					[JRToast showWithText:@"暂无渠道细分请先添加"];
					return;
				}
				DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:@"渠道细分" andBlock:^(NSString *title, NSString *indexStr) {
					MyLog(@"%@    %@",title,indexStr);
					NSInteger number=[indexStr integerValue];
					MJKFunnelChooseModel*model=saveMarketArray[number];
					NSString*postStr=model.c_id;
//					if (self.chooseBlock) {
//						self.chooseBlock(title, postStr);
//					}
					textField.text = title;
					weakSelf.flowModel.C_A41200_C_NAME =  title;
					weakSelf.flowModel.C_A41200_C_ID = postStr;
					
				}];
				[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
				
			}else{
				[JRToast showWithText:data[@"msg"]];
			}
			
		}];
	} else if (self.type == ChooseTableViewTypeStay) {
		NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41400_C_STAYTIME"];
		NSMutableArray*mtArray=[NSMutableArray array];
		NSMutableArray*postArray=[NSMutableArray array];
		for (MJKDataDicModel*model in dataArray) {
			[mtArray addObject:model.C_NAME];
			[postArray addObject:model.C_VOUCHERID];
		}
		DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeMimute andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
			MyLog(@"%@    %@",title,indexStr);
			NSInteger number=[indexStr integerValue];
			NSString*postStr=postArray[number];
//			if (self.chooseBlock) {
//				self.chooseBlock(title, postStr);
//			}
			textField.text = title;
			weakSelf.flowModel.C_STAYTIME_DD_NAME =  title;
			weakSelf.flowModel.C_STAYTIME_DD_ID = postStr;
			
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
	} else {
		
	}
	
}

- (void)textViewDidChange:(UITextView *)textView {
	self.flowModel.C_ATTENDANT = textView.text;
}

- (void)updateDetailCell:(NSArray *)titleArr andModel:(MJKFlowDetailModel *)model andRow:(NSInteger)row {
	self.titleLabel.text = titleArr[row];
	switch (row) {
		case 0: {
			NSString *str;
			if (model.C_PHONE.length > 0) {
				if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
					str = model.C_PHONE;
				} else {
					str = [model.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
				}
			}
			self.contentLabel.text = str;
		}
			break;
		case 1:
			self.contentLabel.text = model.D_ARRIVAL_TIME;
			break;
		case 2:
			self.contentLabel.text = model.C_A41200_C_NAME;
			break;
			
		default:
			break;
	}
}

- (void)updatePhoneCell:(NSString *)title andContent:(NSString *)str {
	self.contentLabel.hidden = NO;
	self.phoneNumber.hidden = YES;
	self.titleLabel.text = title;
	self.contentLabel.text = str;
	[self.phoneNumber addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)addPhoneCell:(NSArray *)title andRow:(NSInteger)row{
	self.titleLabel.text = title[row];
	if (row == 0) {
		self.contentLabel.hidden = NO;
		self.contentLabel.text = @"请选择";
	} else {
		self.contentLabel.hidden = YES;
		self.phoneNumber.hidden = NO;
		self.phoneNumber.placeholder = @"请输入";
		self.phoneNumber.borderStyle = UITextBorderStyleNone;
		[self.phoneNumber addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
	}
}

- (void)changeText:(UITextField *)textField {
	if (self.backTextBlock) {
		self.backTextBlock(textField.text);
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKFlowDetailTableViewCell";
	MJKFlowDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

@end
