//
//  CGCTalkTable.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CGCTalkTableText,//文本
    CGCTalkTablePic_Text,//图文
    CGCTalkTablePic,//图片
    CGCTalkTableVoice,//音频
    CGCTalkTableVideo,//视频
    CGCTalkTableTemplate,//模板
    CGCTalkTableFile,//文件
    
} CGCTalkTableStyle;

typedef enum : NSUInteger {
    EidtUp,//文本
    EidtDown//图文
    
} EidtStyle;


@class CGCTalkTable;
@protocol CGCTalkTableDelegate<NSObject>

- (void)talkTable:(CGCTalkTable *)talk didSelectWithIndex:(NSIndexPath*)indexPath withSelectText:(NSString *)text withSelC_ID:(NSString *)C_ID;

- (void)talkTable:(CGCTalkTable *)talk didClickWithTitle:(NSString *)title;

- (void)talkTable:(CGCTalkTable *)talk didClickEidtIndex:(NSIndexPath *)indexPath withEidt:(EidtStyle)eidtStyle withTitle:(NSString *)title;

@end


@interface CGCTalkTable : UIView

- (void)reloadTableWithArray:(NSMutableArray *)arr withStyle:(CGCTalkTableStyle)style;
- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr withStyle:(CGCTalkTableStyle)style withEidt:(EidtStyle)eidtStyle;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic, weak)  id<CGCTalkTableDelegate>delegate;
@end
