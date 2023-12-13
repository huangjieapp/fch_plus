//
//  MJKWorkWorldListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldListCell.h"

#import "MJKWorkWorldListModel.h"

#import "MJKWorkWorldObjectMapModel.h"
#import "MJKWorkWorldObjectMapContentModel.h"
#import "MJKWorkReportDetailSubModel.h"

#import "MJKWorkWorldTodayCompleteCell.h"


@interface MJKWorkWorldListCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *giveLikeButton;
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *workContentView;

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

@implementation MJKWorkWorldListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)gotoPresonal:(UIButton *)sender {
	if (self.clickGotoPresonalBlock) {
		self.clickGotoPresonalBlock();
	}
}

- (void)setModel:(MJKWorkWorldListModel *)model {
	_model = model;
	DBSelf(weakSelf);
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
	self.nameLabel.text = model.USER_NAME;
	self.releaseTimeLabel.text = model.OUTDATED;
	[self.commentsButton setTitleNormal:model.comments];
	[self.giveLikeButton setTitleNormal:model.fabulous];
    [self.giveLikeButton setImage:[model.fabulous_flag isEqualToString:@"1"] ? @"工作圈_点赞亮" : @"工作圈_点赞"];
	
	CGFloat width = KScreenWidth - 70;
	//有文字
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor blackColor];
	label.numberOfLines = 0;
	[self.workContentView addSubview:label];
	if ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
		if (model.objectMap.X_ZRPLAN.length > 0) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[原计划备注]:\n%@",self.model.objectMap.X_ZRPLAN]];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, 8)];
			NSString *str = [NSString stringWithFormat:@"[原计划备注]:\n%@",model.objectMap.X_ZRPLAN];
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
			tableview.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, width, model.objectMap.content.count * 20 + 20 + size.height + jrRemarkSize.height + mrRemarkSize.height);
//            tableview.hidden = NO;
			[showButton setTitleNormal:@"收起"];
		} else {
//            tableview.hidden = YES;
			tableview.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, width, 100);
			[showButton setTitleNormal:@"全文"];
		}
		
		showButton.frame = CGRectMake(0, CGRectGetMaxY(tableview.frame), width, 20);
		
	} else {
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.model.objectMap.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.detailStr.length > 0) {
//        MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
//        if (contentModel.isSelected == YES) {
//            CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70 - 50, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//            return 20 + size.height;
//        }
//    }
    if (self.model.detailStr.length > 0) {
        MJKWorkWorldObjectMapContentModel *contentModel = self.model.objectMap.content[indexPath.row];
        if (contentModel.isSelected == YES) {
            CGSize size = [self.model.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 70 - 50, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            return 20 + size.height;
        }
    }
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat width = KScreenWidth - 70 - 50;
    CGSize size;
    if (self.model.objectMap.X_MRPLANDETAILED.length > 0) {
        NSString *str = [NSString stringWithFormat:@"\n[明日计划]:\n%@",self.model.objectMap.X_MRPLANDETAILED];
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
	return size.height + jrRemarkSize.height + mrRemarkSize.height;
}
static MJKWorkWorldObjectMapContentModel *selectModel;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
//    bgView.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors=@[(__bridge id)[UIColor colorWithHex:@"#EFEEF3"].CGColor,(__bridge id)[UIColor colorWithHex:@"#FFFFFF"].CGColor];
    //分割点  设置 风电设置不同渐变的效果也不相同
    gradinentlayer.locations=@[@0.0,@1.0];
    gradinentlayer.startPoint=CGPointMake(0, 0);
    gradinentlayer.endPoint=CGPointMake(0, 1.0);
    gradinentlayer.frame=CGRectMake(0, 0, self.tableView.frame.size.width, 20);
    [bgView.layer addSublayer:gradinentlayer];
    
    
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, bgView.frame.size.height)];
	label.text = @"今日完成";
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
    
    
    
    UILabel *tailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 60, 0, 80, 20)];
    tailLabel.text = @"计划完成";
    tailLabel.textColor = [UIColor grayColor];
    tailLabel.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:tailLabel];
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
    
    CGSize size;
    if (self.model.objectMap.X_MRPLANDETAILED.length > 0) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n[明日计划]:\n%@",self.model.objectMap.X_MRPLANDETAILED]];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange([@"\n" length], 6)];
        NSString *str = [NSString stringWithFormat:@"\n[明日计划]:\n%@",self.model.objectMap.X_MRPLANDETAILED];
         size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        
        label.frame = CGRectMake(0, CGRectGetMaxY(jrlabel.frame), width, size.height);
        label.attributedText = attStr;
    } else {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"\n[明日计划]:"];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange([@"\n" length], 6)];
        NSString *str = @"\n[明日计划]:";
         size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
        label.frame = CGRectMake(0, CGRectGetMaxY(jrlabel.frame), width, size.height);
        label.attributedText = attStr;
    }
    
    
    
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
    bgView.frame = CGRectMake(0, 0, width, size.height + jrRemarkSize.height + mrRemarkSize.height);
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
	static NSString *ID = @"MJKWorkWorldListCell";
	MJKWorkWorldListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
			remarkHeight = [[NSString stringWithFormat:@"[原计划备注]:\n%@",model.objectMap.X_ZRPLAN] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height + 20;
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
			remarkHeight += model.objectMap.content.count * 20 + 20 + size.height+ jrRemarkSize.height + mrRemarkSize.height ;
        } else {
            remarkHeight += 90;
        }
	} else {
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
                imageHeight = (width / 3 * ( model.urlList.count % 3 != 0 ? (model.urlList.count / 3 + 1) : (model.urlList.count / 3))) + ([model.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 20 : 10) ;
            }
			
		}
	}
	CGSize addressSize = CGSizeZero;
	if (model.C_ADDRESS.length > 0) {
		addressSize = [model.C_ADDRESS boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
	}
	
	return 44 + 30 + imageHeight + addressSize.height + remarkHeight;
}
@end
