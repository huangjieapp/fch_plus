//
//  MJKWorkWorldListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldNewListCell.h"

#import "MJKWorkWorldListModel.h"

#import "MJKWorkWorldObjectMapModel.h"
#import "MJKWorkWorldObjectMapContentModel.h"
#import "MJKWorkReportDetailSubModel.h"

#import "MJKWorkWorldTodayCompleteCell.h"
#import "MJKWorkTomorrowTableViewCell.h"


@interface MJKWorkWorldNewListCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *giveLikeButton;
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *workContentView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

/** remark label*/
@property (nonatomic, strong) UILabel *remorkLabel;
/** table*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *showButton;
/** <#注释#>*/
@property (nonatomic, assign) CGFloat imageLineHeight;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *imageArray;
/** 选中的MJKWorkWorldObjectMapContentModel*/
//@property (nonatomic, strong) MJKWorkWorldObjectMapContentModel *selectModel;

@end

@implementation MJKWorkWorldNewListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)gotoPresonal:(UIButton *)sender {
	if (self.clickGotoPresonalBlock) {
		self.clickGotoPresonalBlock();
	}
}

- (IBAction)editButtonAction:(UIButton *)sender {
    if (self.clickEditButtonBlock) {
        self.clickEditButtonBlock();
    }
}
- (IBAction)newShareButtonAction:(id)sender {
    if (self.newShareButtonActionBlock) {
        self.newShareButtonActionBlock();
    }
}

- (void)redPackageShowBigImage {
    
}

- (void)setModel:(MJKWorkWorldListModel *)model {
	_model = model;
	DBSelf(weakSelf);
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-头像"]];
	self.nameLabel.text = model.USER_NAME;
	self.releaseTimeLabel.text = model.D_CREATE_TIME;
	[self.commentsButton setTitleNormal:model.comments];
	[self.giveLikeButton setTitleNormal:model.fabulous];
    [self.giveLikeButton setImage:[model.fabulous_flag isEqualToString:@"1"] ? @"工作圈_点赞亮" : @"工作圈_点赞"];
    
    NSString *create_time;
    if (model.D_CREATE_TIME.length > 0) {
        create_time = [model.D_CREATE_TIME substringToIndex:10];
    }
    
    
    if ([model.USER_ID isEqualToString:[NewUserSession instance].user.u051Id] && [create_time isEqualToString:[DBTools getYearMonthDayTime]] && [model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
        self.editButton.hidden = NO;
    } else {
        self.editButton.hidden = YES;
    }
	
	CGFloat width = KScreenWidth - 70;
	//有文字
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor blackColor];
	label.numberOfLines = 0;
	[self.workContentView addSubview:label];
	if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
		if (model.objectMap.X_ZRPLAN.length > 0) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原计划备注\n%@",self.model.objectMap.X_ZRPLAN]];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName :[UIFont fontWithName:@"Helvetica-Bold" size:14.f]} range:NSMakeRange(0, 5)];
			NSString *str = [NSString stringWithFormat:@"原计划备注\n%@",model.objectMap.X_ZRPLAN];
			CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			
			label.frame = CGRectMake(0, 0, width, size.height);
			label.attributedText = attStr;
		} else {
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"[原计划备注]:\n暂无计划"];
//            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 6)];
//            NSString *str = @"[原计划备注]:\n暂无计划";
//            CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//            label.frame = CGRectMake(0, 0, width, size.height);
//            label.attributedText = attStr;
		}
		
		
		
		UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		self.tableView = tableview;
        tableview.backgroundColor = [UIColor whiteColor];
		tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableview.scrollEnabled = NO;
		tableview.delegate = self;
		tableview.dataSource = self;
		[self.workContentView addSubview:tableview];
		
		UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.showButton = showButton;
		showButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		[showButton setTitleNormal:@"全文"];
        [showButton setTitleColor:[UIColor colorWithHex:@"#042979"]];
		showButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
		[showButton addTarget:self action:@selector(showAllTextAction:)];
		[self.workContentView addSubview:showButton];
        
		if (model.objectMap.isSelected == YES) {
            CGSize size;
            if (model.objectMap.X_MRPLANDETAILED.length > 0) {
                NSString *str = [NSString stringWithFormat:@"\n[明日计划]:\n%@",model.objectMap.X_MRPLANDETAILED];
                size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
                
            } else {
                NSString *str = @"\n[明日计划]:";
                size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            }
            CGSize jrRemarkSize;
            if (self.model.objectMap.X_REMARK.length > 0) {
                NSString *str = [NSString stringWithFormat:@"今日备注:\n%@",self.model.objectMap.X_REMARK];
                jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
                
            } else {
                NSString *str = @"今日备注:\n暂无备注";
                jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            }
            
            CGSize mrRemarkSize;
            if (self.model.objectMap.X_MRPLAN.length > 0) {
                NSString *str = [NSString stringWithFormat:@"计划备注:\n%@",self.model.objectMap.X_MRPLAN];
                mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
                
            } else {
                NSString *str = @"计划备注:\n暂无备注";
                mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            }
			tableview.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, width, (model.objectMap.content.count * 20 + 20) * 2  + jrRemarkSize.height + mrRemarkSize.height + 40);
//            tableview.hidden = NO;
			[showButton setTitleNormal:@"收起"];
		} else {
//            tableview.hidden = YES;
			tableview.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, width, 100 + 40);
			[showButton setTitleNormal:@"全文"];
		}
		
		showButton.frame = CGRectMake(0, CGRectGetMaxY(tableview.frame), width, 20);
		
    } else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0003"]) {//红包
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125, 200)];
        imageView.image = [UIImage imageNamed:@"红包_背景_带文字"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(redPackageShowBigImage)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [self.workContentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, imageView.frame.size.width, 30)];
        label.text = self.model.objectMap.C_TYPE_DD_NAME;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:@"#e6cc9b"];
        label.font = [UIFont systemFontOfSize:10.f];
        [imageView addSubview:label];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, imageView.frame.size.width, 30)];
        moneyLabel.text = self.model.objectMap.B_AMOUNT;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.textColor = [UIColor colorWithHex:@"#e6cc9b"];
        moneyLabel.font = [UIFont systemFontOfSize:12.f];
        [imageView addSubview:moneyLabel];
        
    }  else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0005"]) {//罚单
        UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, (model.objectMap.content.count * 55) + 46 + (30 * 4))];
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [UIColor colorWithHex:@"#d7d3d3"].CGColor;
        [self.workContentView addSubview:imageView];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 46)];
        titleView.backgroundColor = [UIColor whiteColor];
        UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, titleView.frame.size.height - 20, titleView.frame.size.height - 20)];
        headIV.image = [UIImage imageNamed:@"罚单目标"];
        [titleView addSubview:headIV];
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headIV.frame) + 5, 0, imageView.frame.size.width - titleView.frame.size.height - 10, titleView.frame.size.height)];
        headLabel.font = [UIFont systemFontOfSize:14.f];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@的罚单 %@",model.objectMap.C_OWNER_ROLENAME,model.objectMap.D_CREATE_TIME]];
        [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(model.objectMap.C_OWNER_ROLENAME.length + 4, model.objectMap.D_CREATE_TIME.length)];
        headLabel.attributedText = str;
        headLabel.textColor = [UIColor colorWithHex:@"#717171"];
        [titleView addSubview:headLabel];
        UIImageView *statusIV = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.size.width - titleView.frame.size.height - 15, 0, titleView.frame.size.height + 10, titleView.frame.size.height - 1)];
        statusIV.contentMode = UIViewContentModeScaleAspectFit;
        statusIV.image = [UIImage imageNamed:[model.objectMap.C_STATUS_DD_ID isEqualToString:@"A71100_C_STATUS_0003"] ? @"icon_unpay" : @"icon_pay"];
        [titleView addSubview:statusIV];
        UIView *sectionSep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusIV.frame), imageView.frame.size.width, 1)];
        sectionSep.backgroundColor = [UIColor colorWithHex:@"#d7d3d3"];
        [titleView addSubview:sectionSep];
        
        [imageView addSubview:titleView];
        
        NSArray *contentArr = model.objectMap.content;//MJKWorkWorldObjectMapContentModel
        UIView *contentMainView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), imageView.frame.size.width, model.objectMap.content.count * 55 + 1)];
        for (int i = 0; i < contentArr.count; i++) {
            MJKWorkWorldObjectMapContentModel *contentModel = contentArr[i];
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 51 * i, imageView.frame.size.width, 51)];
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, imageView.frame.size.width / 2, 30)];
            contentLabel.font = [UIFont systemFontOfSize:14.f];
            contentLabel.text = contentModel.C_VOUCHERNAME;
            contentLabel.textColor = [UIColor blackColor];
            [contentView addSubview:contentLabel];
            UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width / 2 + 5, 5, imageView.frame.size.width / 2 - 20, 30)];
            moneyLabel.textAlignment = NSTextAlignmentRight;
            moneyLabel.font = [UIFont systemFontOfSize:14.f];
            moneyLabel.text = contentModel.B_AMOUNT;
            moneyLabel.textColor = [UIColor blackColor];
            [contentView addSubview:moneyLabel];
            UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(moneyLabel.frame), imageView.frame.size.width - 20, 20)];
            countLabel.textAlignment = NSTextAlignmentRight;
            countLabel.font = [UIFont systemFontOfSize:12];
            countLabel.text = [NSString stringWithFormat:@"x%@",contentModel.I_YCS];
            countLabel.textColor = [UIColor darkGrayColor];
            [contentView addSubview:countLabel];
            [contentMainView addSubview:contentView];
        }
        UIView *sectionSep_1 = [[UIView alloc]initWithFrame:CGRectMake(0, contentMainView.frame.size.height - 1, imageView.frame.size.width, 1)];
        sectionSep_1.backgroundColor = [UIColor colorWithHex:@"#d7d3d3"];
        [contentMainView addSubview:sectionSep_1];
        [imageView addSubview:contentMainView];
        
        UILabel *totalLabel_left = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(contentMainView.frame), imageView.frame.size.width / 2, 30)];
//        countLabel.textAlignment = NSTextAlignmentRight;
        totalLabel_left.font = [UIFont systemFontOfSize:14.f];
        totalLabel_left.text = @"合计金额";
        totalLabel_left.textColor = [UIColor blackColor];
        [imageView addSubview:totalLabel_left];
        UILabel *totalLabel_right = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width / 2, CGRectGetMaxY(contentMainView.frame) , imageView.frame.size.width / 2 - 10, 30)];
        totalLabel_right.textAlignment = NSTextAlignmentRight;
        totalLabel_right.font = [UIFont systemFontOfSize:14.f];
        totalLabel_right.text = [NSString stringWithFormat:@"%@元",model.objectMap.B_HJJE];
        totalLabel_right.textColor = [UIColor blackColor];
        [imageView addSubview:totalLabel_right];
        
        UILabel *tzLabel_left = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(totalLabel_left.frame), imageView.frame.size.width / 2, (model.objectMap.B_TZJE.length > 0 && ![model.objectMap.B_TZJE isEqualToString:@"0.00"]) > 0 ? 30 : 0)];
        //        countLabel.textAlignment = NSTextAlignmentRight;
        tzLabel_left.font = [UIFont systemFontOfSize:14.f];
        tzLabel_left.text = @"调整金额";
        tzLabel_left.textColor = [UIColor blackColor];
        UILabel *tzLabel_right = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width / 2, CGRectGetMaxY(totalLabel_left.frame), imageView.frame.size.width / 2 - 10, (model.objectMap.B_TZJE.length > 0 && ![model.objectMap.B_TZJE isEqualToString:@"0.00"]) ? 30 : 0)];
        tzLabel_right.textAlignment = NSTextAlignmentRight;
        tzLabel_right.font = [UIFont systemFontOfSize:14.f];
        tzLabel_right.text = [NSString stringWithFormat:@"%@元",model.objectMap.B_TZJE];
        tzLabel_right.textColor = [UIColor blackColor];
        if (model.objectMap.B_TZJE.length > 0 && [model.objectMap.B_TZJE isEqual:@"0.00"]) {
            [imageView addSubview:tzLabel_left];
            [imageView addSubview:tzLabel_right];
        }
        
        UILabel *tzRemarkLabel_left = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tzLabel_left.frame), 90, (model.objectMap.B_TZJE.length > 0 && ![model.objectMap.B_TZJE isEqualToString:@"0.00"]) ? 30 : 0)];
        //        countLabel.textAlignment = NSTextAlignmentRight;
        tzRemarkLabel_left.font = [UIFont systemFontOfSize:14.f];
        tzRemarkLabel_left.text = @"调整原因";
        tzRemarkLabel_left.textColor = [UIColor blackColor];
        UILabel * tzRemarkLabel_right = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 95, CGRectGetMaxY(tzLabel_left.frame) , imageView.frame.size.width - 100, (model.objectMap.B_TZJE.length > 0 && ![model.objectMap.B_TZJE isEqualToString:@"0.00"]) ? 30 : 0)];
        tzRemarkLabel_right.textAlignment = NSTextAlignmentRight;
        tzRemarkLabel_right.font = [UIFont systemFontOfSize:14.f];
        tzRemarkLabel_right.text = [NSString stringWithFormat:@"%@",model.objectMap.X_REMARK];
        tzRemarkLabel_right.textColor = [UIColor blackColor];
        if (model.objectMap.B_TZJE.length > 0 && [model.objectMap.B_TZJE isEqual:@"0.00"]) {
            [imageView addSubview:tzRemarkLabel_left];
            [imageView addSubview:tzRemarkLabel_right];
        }
        
        UILabel *finalLabel_left = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tzRemarkLabel_left.frame), imageView.frame.size.width / 2, 30)];
        //        countLabel.textAlignment = NSTextAlignmentRight;
        finalLabel_left.font = [UIFont systemFontOfSize:14.f];
        finalLabel_left.text = @"处罚金额";
        finalLabel_left.textColor = [UIColor blackColor];
        [imageView addSubview:finalLabel_left];
        UILabel *finalLabel_right = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width / 2, CGRectGetMaxY(tzRemarkLabel_left.frame), imageView.frame.size.width / 2 - 10, 30)];
        finalLabel_right.textAlignment = NSTextAlignmentRight;
        finalLabel_right.font = [UIFont systemFontOfSize:14.f];
        finalLabel_right.text = [NSString stringWithFormat:@"¥%@元",model.objectMap.B_AMOUNT];
        finalLabel_right.textColor = [UIColor redColor];
        [imageView addSubview:finalLabel_right];
    }else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0004"] || [model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0006"]) {
        if (model.objectMap.X_REMARK.length > 0 || model.X_REMINDINGNAME.length > 0) {
            NSString *str;
            if (model.X_REMINDINGNAME.length > 0) {
                if (model.objectMap.X_REMARK.length > 0) {
                    str = [NSString stringWithFormat:@"%@\n提到了:%@",model.objectMap.X_REMARK, model.X_REMINDINGNAME];
                } else {
                    
                    str = [NSString stringWithFormat:@"提到了:%@", model.X_REMINDINGNAME];
                }
            } else {
                str = model.objectMap.X_REMARK;
            }
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
            if (model.X_REMINDINGNAME.length > 0) {
                if (model.objectMap.X_REMARK.length > 0) {
                    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#ABABAA"], NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(model.objectMap.X_REMARK.length , model.X_REMINDINGNAME.length + [@"\n提到了:" length])];
                } else {
                    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#ABABAA"], NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(0 , model.X_REMINDINGNAME.length + [@"提到了:" length])];
                }
                
            }
            
            CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
            label.frame = CGRectMake(0, 0, width, size.height);
            label.attributedText = attStr;
            self.remorkLabel = label;
        }
    }
    else {
    if (model.X_REMARK.length > 0 || model.X_REMINDINGNAME.length > 0) {
            NSString *str;
            if (model.X_REMINDINGNAME.length > 0) {
                if (model.X_REMARK.length > 0) {
                    str = [NSString stringWithFormat:@"%@\n提到了:%@",model.X_REMARK, model.X_REMINDINGNAME];
                } else {
                    
                    str = [NSString stringWithFormat:@"提到了:%@", model.X_REMINDINGNAME];
                }
            } else {
                str = model.X_REMARK;
            }
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
            if (model.X_REMINDINGNAME.length > 0) {
                if (model.X_REMARK.length > 0) {
                    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#ABABAA"], NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(model.X_REMARK.length , model.X_REMINDINGNAME.length + [@"\n提到了:" length])];
                } else {
                    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#ABABAA"], NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(0 , model.X_REMINDINGNAME.length + [@"提到了:" length])];
                }
                
            }
           
			CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			
			label.frame = CGRectMake(0, 0, width, size.height);
			label.attributedText = attStr;
			self.remorkLabel = label;
		}
	}
	
	//有图片
	CGFloat imageLineHeight = 0;
	if (model.urlList.count > 0) {
		CGFloat imageWidth = (width - 10) / 3;
		if (model.urlList.count == 1) {//只有一张图片
			__block CGRect frame = CGRectZero ;
			UIImageView *imageView = [[UIImageView alloc]init];
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
			[self.workContentView addSubview:imageView];
			[imageView sd_setImageWithURL:[NSURL URLWithString:model.urlList[0]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				double proportion = image.size.width / image.size.height;
				double imageWidth = 0;
				double imageHeight = 0;
				if (proportion > 1) {
					imageWidth =  (KScreenWidth - 50 - 70);
					imageHeight = (KScreenWidth - 50 - 70) / proportion;
				} else if (proportion < 1) {
					imageWidth =  (KScreenWidth - 50 - 70) * proportion;
					imageHeight = (KScreenWidth - 50 - 70);
				} else {
					imageWidth = imageHeight = (KScreenWidth - 50 - 70) / 3;
				}
                if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
                    imageWidth = imageHeight = (KScreenWidth - 50 - 70) / 3;
                }
//				UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.urlList[0]]]];
				frame = CGRectMake(0,[model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? (CGRectGetMaxY(weakSelf.tableView.frame) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 30 : 10)) : (CGRectGetMaxY(weakSelf.remorkLabel.frame) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 30 : 10)), imageWidth , imageHeight);
			}];
            
			imageView.frame = frame;
			imageLineHeight = frame.size.height + imageView.frame.origin.y;
			
			UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBigImage:)];
			[imageView addGestureRecognizer:tapGR];
			imageView.userInteractionEnabled = YES;
			imageView.tag = 1000;
            self.imageLineHeight  = imageLineHeight;
            [self.imageArray addObject:imageView];
		} else {
			for (int i = 0; i < model.urlList.count; i++) {
				UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i % 3) * (imageWidth + 5),([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? (CGRectGetMaxY(weakSelf.tableView.frame) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 30 : 10)) : (CGRectGetMaxY(weakSelf.remorkLabel.frame) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 30 : 10))) +  (i / 3) * (imageWidth + 5), imageWidth, imageWidth)];
				[self.workContentView addSubview:imageView];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
				[imageView sd_setImageWithURL:[NSURL URLWithString:model.urlList[i]] ];
				if (i == 0) {
					imageLineHeight += imageView.frame.origin.y;
				}
//				else {
//					imageLineHeight += imageView.frame.size.height;
//					//( model.urlList.count % 3 != 0 ? (model.urlList.count / 3 + 1) : (model.urlList.count / 3))
//				}
				
				
				UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBigImage:)];
				[imageView addGestureRecognizer:tapGR];
				imageView.tag = 1000 + i;
				imageView.userInteractionEnabled = YES;
                
                [self.imageArray addObject:imageView];
			}
			imageLineHeight += (width / 3) * ( model.urlList.count % 3 != 0 ? (model.urlList.count / 3 + 1) : (model.urlList.count / 3));
            self.imageLineHeight  = imageLineHeight;
		}
	} else {
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
		[self.workContentView addSubview:imageView];
		imageLineHeight = self.remorkLabel.frame.size.height;
	}
	//有地址
	UIButton *addressButton = [[UIButton alloc]initWithFrame:CGRectZero];
	[self.workContentView addSubview:addressButton];
	if (model.C_ADDRESS.length > 0) {
		addressButton.frame = CGRectMake(0, imageLineHeight + 5, width, 20);
		[addressButton setTitleNormal:model.C_ADDRESS];
//        [addressButton setImage:@"签到地点图标"];
        [addressButton addTarget:self action:@selector(toSignDetailAction:)];
		addressButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [addressButton setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
		addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	} 
}

#pragma mark - 签到详情
- (void)toSignDetailAction:(UIButton *)sender {
    if (self.signDetailBlock) {
        self.signDetailBlock();
    }
}

#pragma mark - 点击放大图片
- (void)clickBigImage:(UITapGestureRecognizer *)tapGR {
	UITapGestureRecognizer *tap = (UITapGestureRecognizer*)tapGR;
	
	UIImageView *views = (UIImageView*) tap.view;
	if (self.clickBigImgeBlock) {
		self.clickBigImgeBlock(views);
	}
}

#pragma mark 点击展示全文或收起
- (void)showAllTextAction:(UIButton *)sender {
	if (self.clickShowAllTextBlock) {
		self.clickShowAllTextBlock([sender.titleLabel.text isEqualToString:@"全文"] ? YES : NO);
	}
}

#pragma mark - 如果是日报加个tablevie
- (void)setDetailStr:(NSString *)detailStr {
	_detailStr = detailStr;
    CGSize detailSize = CGSizeZero;
    if (detailStr.length > 0) {
        detailSize = [detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    }
    CGRect rect = self.tableView.frame;
    rect.size.height = rect.size.height + detailSize.height;
    self.tableView.frame = rect;

    CGRect showButtonFrame = self.showButton.frame;
    if (self.imageArray.count > 0) {
        for (UIImageView *imageView in self.imageArray) {
            CGRect imageFrame = imageView.frame;
            imageFrame.origin.y = imageFrame.origin.y + detailSize.height;
            imageView.frame = imageFrame;
        }
        UIImageView *lastImageView = self.imageArray.lastObject;
        showButtonFrame.origin.y = CGRectGetMaxY(lastImageView.frame);
    } else {
        showButtonFrame.origin.y = CGRectGetMaxY(self.tableView.frame);
    }
    self.showButton.frame = showButtonFrame;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.model.objectMap.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
    if (indexPath.section == 0) {
        MJKWorkWorldTodayCompleteCell *cell = [MJKWorkWorldTodayCompleteCell cellWithTableView:tableView];
        cell.model = contentModel;
        if (contentModel.isSelected == YES) {
            cell.detailLabel.hidden = NO;
            //        cell.detailLabel.text = self.detailStr;
            cell.detailLabel.text = self.model.detailStr;
        } else {
            cell.detailLabel.hidden = YES;
        }
        return cell;
    } else {
        MJKWorkTomorrowTableViewCell *cell = [MJKWorkTomorrowTableViewCell cellWithTableView:tableView];
        cell.typeNameLabel.text = contentModel.C_TYPE_DD_NAME;
        cell.monthLabel.text = [NSString stringWithFormat:@"%@",contentModel.I_TARGETNUMBER];
        cell.completeLabel.text = [NSString stringWithFormat:@"%@",contentModel.B_TOTAL_BY];
        cell.totalLabel.text = [NSString stringWithFormat:@"%@%@",contentModel.B_TOTAL_JH_MR,contentModel.UNIT];
        return cell;
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.detailStr.length > 0) {
//        MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
//        if (contentModel.isSelected == YES) {
//            CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70 - 50, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//            return 20 + size.height;
//        }
//    }
    if (indexPath.section == 0) {
        if (self.model.detailStr.length > 0) {
            MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
            if (contentModel.isSelected == YES) {
                CGSize size = [self.model.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70 - 50, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
                return 20 + size.height;
            }
        }
    }
    
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat width = KScreenWidth - 70 - 50;
    if (section == 0) {
        CGSize jrRemarkSize;
        if (self.model.objectMap.X_REMARK.length > 0) {
            NSString *str = [NSString stringWithFormat:@"今日备注:\n%@",self.model.objectMap.X_REMARK];
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
        } else {
            NSString *str = @"今日备注:\n暂无备注";
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        }
        return jrRemarkSize.height;
    } else {
        CGSize mrRemarkSize;
        if (self.model.objectMap.X_MRPLAN.length > 0) {
            NSString *str = [NSString stringWithFormat:@"计划备注:\n%@",self.model.objectMap.X_MRPLAN];
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
        } else {
            NSString *str = @"计划备注:\n暂无备注";
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        }
        return mrRemarkSize.height;
    }
}
static MJKWorkWorldObjectMapContentModel *selectModel;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        selectModel.selected = NO;
        MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
        if (contentModel.X_REMARK.length <= 0 && self.model.detailStr <= 0) {
            contentModel.selected = NO;
        } else {
            contentModel.selected = YES;
        }
        selectModel = contentModel;
        if (self.clickDetailWorkReportBlock) {
            self.clickDetailWorkReportBlock(indexPath);
        }
    }
	
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
//    bgView.backgroundColor = [UIColor whiteColor];
    
//    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
//    gradinentlayer.colors=@[(__bridge id)[UIColor colorWithHex:@"#EFEEF3"].CGColor,(__bridge id)[UIColor colorWithHex:@"#FFFFFF"].CGColor];
//    //分割点  设置 风电设置不同渐变的效果也不相同
//    gradinentlayer.locations=@[@0.0,@1.0];
//    gradinentlayer.startPoint=CGPointMake(0, 0);
//    gradinentlayer.endPoint=CGPointMake(0, 1.0);
//    gradinentlayer.frame=CGRectMake(0, 0, self.tableView.frame.size.width, 20);
//    [bgView.layer addSublayer:gradinentlayer];
    
    if (section == 0) {
        if (self.model.objectMap.X_ZRPLAN.length > 0) {
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, bgView.frame.size.width, 1)];
            sepView.backgroundColor = kBackgroundColor;
            [bgView addSubview:sepView];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
        label.text = @"今日完成";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
        [bgView addSubview:label];
        
        
        
        UILabel *tailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 60, 10, 80, 20)];
        tailLabel.text = @"计划完成";
        tailLabel.textColor = [UIColor blackColor];
        tailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
        [bgView addSubview:tailLabel];
    } else {
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, bgView.frame.size.width, 1)];
        sepView.backgroundColor = kBackgroundColor;
        [bgView addSubview:sepView];
        for (int i = 0; i < 4; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i * ((self.tableView.frame.size.width) / 4)), 10, (self.tableView.frame.size.width) / 4, 20)];
            label.text = @[@"明日计划",@"月目标",@"已完成",@"计划"][i];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            } else{
                label.textAlignment = NSTextAlignmentCenter;
            }
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
            [bgView addSubview:label];
        }
    }
	
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat width = KScreenWidth - 70 - 50;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    //有文字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [bgView addSubview:label];
    
    UILabel *jrlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    jrlabel.font = [UIFont systemFontOfSize:14.f];
    jrlabel.textColor = [UIColor blackColor];
    jrlabel.numberOfLines = 0;
    [bgView addSubview:jrlabel];
    
    UILabel *mrlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    mrlabel.font = [UIFont systemFontOfSize:14.f];
    mrlabel.textColor = [UIColor blackColor];
    mrlabel.numberOfLines = 0;
    [bgView addSubview:mrlabel];
    
    if (section == 0) {
        CGSize jrRemarkSize;
        if (self.model.objectMap.X_REMARK.length > 0) {
            NSString *str = [NSString stringWithFormat:@"今日备注:\n%@",self.model.objectMap.X_REMARK];
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            jrlabel.frame = CGRectMake(0, 0, width, jrRemarkSize.height);
            jrlabel.text = str;
        } else {
            NSString *str = @"今日备注:\n暂无备注";
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            jrlabel.frame = CGRectMake(0, 0, width, jrRemarkSize.height);
            jrlabel.text = str;
        }
        
        bgView.frame = CGRectMake(0, 0, width,  jrRemarkSize.height );
    } else {
        CGSize mrRemarkSize;
        if (self.model.objectMap.X_MRPLAN.length > 0) {
            NSString *str = [NSString stringWithFormat:@"计划备注:\n%@",self.model.objectMap.X_MRPLAN];
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            mrlabel.frame = CGRectMake(0, CGRectGetMaxY(label.frame), width, mrRemarkSize.height);
            mrlabel.text = str;
        } else {
            NSString *str = @"计划备注:\n暂无备注";
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            mrlabel.frame = CGRectMake(0, CGRectGetMaxY(label.frame), width, mrRemarkSize.height);
            mrlabel.text = str;
        }
        
        bgView.frame = CGRectMake(0, 0, width,  mrRemarkSize.height);
    }
	return bgView;
}
- (IBAction)givrLikeButtonAction:(UIButton *)sender {
    if (self.giveLikeButtonBlock) {
        self.giveLikeButtonBlock();
    }
}

- (IBAction)commentsButtonAction:(UIButton *)sender {
    if (self.commentsButton) {
        self.commentButtonBlock();
    }
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkWorldNewListCell";
	MJKWorkWorldNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

+ (CGFloat)heightForCell:(MJKWorkWorldListModel *)model {
	CGFloat width = KScreenWidth - 70 - 50;
	CGFloat remarkHeight = 0;
	if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"])  {
		if (model.objectMap.X_ZRPLAN.length > 0) {
			remarkHeight = [[NSString stringWithFormat:@"原计划备注\n%@",model.objectMap.X_ZRPLAN] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height + 20;
		} else {
//            remarkHeight = [@"[原计划备注]:\n暂无计划" boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height + 20;
            remarkHeight = 20;
		}
        CGSize size;
        if (model.objectMap.X_MRPLANDETAILED.length > 0) {
            NSString *str = [NSString stringWithFormat:@"\n[明日计划]:\n%@",model.objectMap.X_MRPLANDETAILED];
            size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
        } else {
            NSString *str = @"\n[明日计划]:";
            size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        }
        CGSize jrRemarkSize;
        if (model.objectMap.X_REMARK.length > 0) {
            NSString *str = [NSString stringWithFormat:@"今日备注:\n%@",model.objectMap.X_REMARK];
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
        } else {
            NSString *str = @"今日备注:\n暂无备注";
            jrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        }
        
        CGSize mrRemarkSize;
        if (model.objectMap.X_MRPLAN.length > 0) {
            NSString *str = [NSString stringWithFormat:@"计划备注:\n%@",model.objectMap.X_MRPLAN];
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            
        } else {
            NSString *str = @"计划备注:\n暂无备注";
            mrRemarkSize = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        }
		if (model.objectMap.isSelected == YES) {
			remarkHeight += (model.objectMap.content.count * 20 + 20) * 2 + jrRemarkSize.height + mrRemarkSize.height + 40;
        } else {
            remarkHeight += 130;
        }
    } else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0003"]) {//红包
        remarkHeight += 200;
        //(model.objectMap.content.count * 50) + 46 + (30 * 4)
    } else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0005"]) {//罚单
        remarkHeight += (model.objectMap.content.count * 55) + 46 + (30 * 4);
    }  else if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0004"] || [model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0006"]) {//任务签到  喜报
        if (model.X_REMINDINGNAME.length > 0) {
            if (model.objectMap.X_REMARK.length > 0) {
                NSString *str = [NSString stringWithFormat:@"%@\n提到了:%@",model.objectMap.X_REMARK, model.X_REMINDINGNAME];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            } else {
                NSString *str = [NSString stringWithFormat:@"提到了:%@", model.X_REMINDINGNAME];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            }
            
        } else {
            if (model.objectMap.X_REMARK.length > 0) {
                NSString *str = [NSString stringWithFormat:@"%@",model.objectMap.X_REMARK];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            }
        }
        //        if (model.X_REMARK.length > 0 || model.X_REMINDINGNAME.length > 0) {
        //            NSString *str = [NSString stringWithFormat:@"%@\n提到了:%@",model.X_REMARK, model.X_REMINDINGNAME];
        //            remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        //        }
    }
    else {
        if (model.X_REMINDINGNAME.length > 0) {
            if (model.X_REMARK.length > 0) {
                NSString *str = [NSString stringWithFormat:@"%@\n提到了:%@",model.X_REMARK, model.X_REMINDINGNAME];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            } else {
                NSString *str = [NSString stringWithFormat:@"提到了:%@", model.X_REMINDINGNAME];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            }
            
        } else {
            if (model.X_REMARK.length > 0) {
                NSString *str = [NSString stringWithFormat:@"%@",model.X_REMARK];
                remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            }
        }
//        if (model.X_REMARK.length > 0 || model.X_REMINDINGNAME.length > 0) {
//            NSString *str = [NSString stringWithFormat:@"%@\n提到了:%@",model.X_REMARK, model.X_REMINDINGNAME];
//            remarkHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
//        }
	}
	
	CGFloat imageHeight = 0;
	if (model.urlList.count > 0) {//如果有图片
		if (model.urlList.count == 1) {
			__block CGFloat height = imageHeight;
			UIImageView *imageView = [[UIImageView alloc]init];
			[imageView sd_setImageWithURL:[NSURL URLWithString:model.urlList[0]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				double proportion = image.size.width / image.size.height;
				double imageHeight = 0;
				if (proportion > 1) {
					height = (KScreenWidth - 50 - 70) / proportion;
				} else if (proportion < 1) {
					height = (KScreenWidth - 50 - 70);
				} else {
					height = imageHeight = (KScreenWidth - 50 - 70) / 3;
				}
                if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
                    height = imageHeight = (KScreenWidth - 50 - 70) / 3;
                }
			}];
			imageHeight = height + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 30 : 10);
		} else {
            if ([model.vcName isEqualToString:@"素材"]) {
                imageHeight = ((width / 3 + 20) * (model.urlList.count % 3 == 0 ? model.urlList.count / 3 : (model.urlList.count / 3 + 1)));
            } else {
                imageHeight = (width / 3 * ( model.urlList.count % 3 != 0 ? (model.urlList.count / 3 + 1) : (model.urlList.count / 3))) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 40 : 10) ;
            }
			
		}
	}
	CGFloat addressHeight = 0;
	if (model.C_ADDRESS.length > 0) {
		addressHeight = [model.C_ADDRESS boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size.height + 8;
	}
	
	return 44 + 44 + imageHeight + addressHeight + remarkHeight;
}
@end
