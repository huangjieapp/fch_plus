//
//  MJKWordsArtTemplateModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWordsArtTemplateModel : MJKBaseModel
/** 话术事件 ID*/
@property (nonatomic, strong) NSString *nlpEventId;
/** 话术事件名称*/
@property (nonatomic, strong) NSString *nlpEventName;
/** nlpThemeId*/
@property (nonatomic, strong) NSString *nlpThemeId;

/** 主题id*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
