//
//  FMDBManager.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "MJKDataDicModel.h"

@interface FMDBManager : NSObject
//{
//  
//    FMDatabase*_fmdb;
//}
#warning 搜索不需要关。 但是单条增删改  完成后记得加     [[FMDBManager sharedFMDBManager].fmdb close];     增和查没有问题。改和删不知道 会不会有问题  没测试
@property(nonatomic,strong) FMDatabase*fmdb;




+ (instancetype)sharedFMDBManager;
-(void)addDataModel:(MJKDataDicModel*)model;   //加上一条数据
-(void)deleteAllDataModel;     //删除所有的数据
-(void)deleteDataModel:(MJKDataDicModel*)model;   //删除一条数据
-(void)updateDataModel:(MJKDataDicModel*)model;   //更新一条数据

-(NSMutableArray*)queryDatasWithC_TYPECODE:(NSString*)C_TYPECODE;   //通过str 查询所有的数据
-(NSMutableArray*)queryAllDatas;      //查询所有的数据


@end
