//
//  MJKHomePagePersonCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePagePersonCell.h"

#import "NoticeInfoModel.h"
#import "ADRollView.h"
#import "ADRollModel.h"
#import "MJKPayModel.h"
#import "MJKHomePageJXModel.h"
#import "NoticeInfoDetailViewController.h"

@interface MJKHomePagePersonCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** noticeTitles*/
@property (nonatomic, strong) NSMutableArray *noticeTitles;
@property (strong, nonatomic) IBOutlet ADRollView *adRollView;
@property (weak, nonatomic) IBOutlet UIView *adBGView;
@property (weak, nonatomic) IBOutlet UILabel *xsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yyLabel;
@property (weak, nonatomic) IBOutlet UILabel *gjLabel;
@property (weak, nonatomic) IBOutlet UILabel *yqLabel;
@property (weak, nonatomic) IBOutlet UILabel *zyLabel;
@end

@implementation MJKHomePagePersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.adRollView = [[ADRollView alloc] initWithFrame:CGRectMake(0, 0, self.adBGView.frame.size.width, self.adBGView.frame.size.height)];
	
	
	//点击公告内容
	__weak __typeof(self)weakSelf = self;
	self.adRollView.clickBlock = ^(NSInteger index) {
		UIViewController*superVC=[DBTools getSuperViewWithsubView:weakSelf];
		NoticeInfoDetailViewController*vc=[[NoticeInfoDetailViewController alloc]init];
		vc.allDatas=weakSelf.allDatas;
		[superVC.navigationController pushViewController:vc animated:YES];
	};
	
	[_adBGView addSubview:self.adRollView];
	
	self.titleLabel.text = [NSString stringWithFormat:@"%@",[NewUserSession instance].user.nickName];
	
	[self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar] placeholderImage:[UIImage imageNamed:@"icon_set_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
}

- (void)setDbModel:(MJKHomePageJXModel *)dbModel{
    _dbModel = dbModel;
    self.xsLabel.text = dbModel.jxb;
    self.yyLabel.text = dbModel.yyb;
    self.gjLabel.text = dbModel.gjb;
    self.yqLabel.text = dbModel.yqb;
}

- (void)setPayModel:(MJKPayModel *)payModel {
    _payModel = payModel;
    NSMutableAttributedString *payStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",payModel.SK_MB]];
    [payStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} range:NSMakeRange(payModel.SK_MB.length, 1)];
    self.payLabel.attributedText = payStr;
    
    NSMutableAttributedString *micountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",payModel.SK_MIDCOUNT]];
    [micountStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} range:NSMakeRange(payModel.SK_MIDCOUNT.length, 1)];
    self.completeLabel.attributedText = micountStr;
    
    NSMutableAttributedString *jrcountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",payModel.SK_JRCOUNT]];
    [jrcountStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} range:NSMakeRange(payModel.SK_JRCOUNT.length, 1)];
    self.todayCompleteLabel.attributedText = jrcountStr;
}

- (IBAction)gotoPayDetailVC:(UIButton *)sender {
    if (self.gotoDetailPayVCBlock) {
        self.gotoDetailPayVCBlock(sender.tag);
    }
    
}
- (IBAction)announcementButtonAction:(UIButton *)sender {
	if (self.announcementButtonActionBlock) {
		self.announcementButtonActionBlock();
	}
}

-(void)getNoticeValue:(NSMutableArray*)mtArray{
	self.allDatas=mtArray;
	if (mtArray.count <= 0) {
		ADRollModel *newModel = [[ADRollModel alloc] init];
		//		newModel.noticeType = nil;
		newModel.noticeTitle = @"近三日暂无公告";
		//		newModel.addTime = @"1020390";
		//		newModel.urlString = nil;
		
		[self.noticeTitles addObject:newModel];
		[self.adRollView stopTimer];
		[self.adRollView setVerticalShowDataArr:self.noticeTitles];
	} else {
		for (NoticeInfoModel*model in mtArray) {
			ADRollModel *newModel = [[ADRollModel alloc] init];
			//		newModel.noticeType = nil;
			newModel.noticeTitle = model.C_TITLE;
			//		newModel.addTime = @"1020390";
			//		newModel.urlString = nil;
			
			[self.noticeTitles addObject:newModel];
			
		}
		
		
		
		[self.adRollView stopTimer];
		[self.adRollView setVerticalShowDataArr:self.noticeTitles];
		[self.adRollView start];
	}
	
	
	
	
}

- (NSMutableArray *)noticeTitles
{
	if (!_noticeTitles) {
		_noticeTitles = [NSMutableArray array];
	}
	return _noticeTitles;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKHomePagePersonCell";
	MJKHomePagePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
