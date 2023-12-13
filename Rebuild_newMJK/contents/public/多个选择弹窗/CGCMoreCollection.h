//
//  CGCMoreCollection.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

/*
 图片数组和标题数组个数要一样
 CGCMoreCollection * more=[[CGCMoreCollection alloc] initWithFrame:self.view.bounds withPicArr:@[@"",@"",@""] withTitleArr:@[@"延迟",@"短信",@"发送客户预览"] withTitle:@"更多操作" withSelectIndex:^(NSInteger index) {

 } ];
 */

#import <UIKit/UIKit.h>

typedef void(^SELECTINDEX)(NSInteger index,NSString * title);

@interface CGCMoreCollection : UIView

- (instancetype)initWithFrame:(CGRect)frame withPicArr:(NSArray *)picArr withTitleArr:(NSArray *)titleArr withTitle:(NSString *)title withSelectIndex:(SELECTINDEX)sel;

@end
