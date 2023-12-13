//
//  FMDBManager.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "FMDBManager.h"



#define KDBName   @"model.sqlite"
#define KTableName   @"DataDic"


static FMDBManager*manager=nil;
@interface FMDBManager()

@end


@implementation FMDBManager

+(instancetype)sharedFMDBManager{
    if (manager==nil) {
        manager=[[FMDBManager alloc]init];
        [manager initDataBase];
    }
    
    return manager;
}

#pragma amrk - fmdb创建数据库
-(void)initDataBase{
    NSString*documentsPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString*filePath=[documentsPath stringByAppendingPathComponent:KDBName];
    
     // 实例化FMDataBase对象
    _fmdb=[FMDatabase databaseWithPath:filePath];
  
    [self fmdbTableCreate];
    
}

#pragma amrk - fmdb创建表
-(void)fmdbTableCreate{
    NSString*sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, C_TYPECODE VARCHAR, C_FATHERVOUCHERID VARCHAR, C_ID VARCHAR, C_NAME VARCHAR, FLAG VARCHAR, I_SORTIDX VARCHAR, C_VOUCHERID VARCHAR);",KTableName];
    [self fmdbExecSql:sql];
    
}


#pragma mark - fmdbUpdate
-(void)fmdbExecSql:(NSString*)sql{
    if ([_fmdb open]) {
        /*
         * 只要sql不是SELECT命令的都视为更新操作(使用executeUpdate方法)。就包括 CREAT,UPDATE,INSERT,ALTER,BEGIN,COMMIT,DETACH,DELETE,DROP,END,EXPLAIN,VACUUM,REPLACE等等。SELECT命令的话，使用executeQuery方法。
         * 执行更新返回一个BOOL值。YES表示 执行成功，否则表示有错误。你可以调用 -lastErrorMessage 和 -lastErrorCode方法来得到更多信息。
         */
        if ([_fmdb executeUpdate:sql]) {
            NSLog(@"%@%@%@",@"fmdb操作表",KTableName,@"成功！");
        }else{
            NSLog(@"%@%@%@ lastErrorMessage：%@，lastErrorCode：%d",@"fmdb创建",KTableName,@"失败！",_fmdb.lastErrorMessage,_fmdb.lastErrorCode);
        }

        
        
        
    }else{
        [JRToast showWithText:@"数据库打开失败"];
    }
    
    
// 会不会 太频繁了 开关数据库     所以  在外面 完成操作了 之后关。
//    [_fmdb close];
    
}


#pragma mark - 传入sql 得到想要的数组model
-(NSMutableArray*)queryNeedModelWithSql:(NSString*)sql{
    [_fmdb open];
    NSMutableArray*dataArray=[NSMutableArray array];
    //根据条件查询
    FMResultSet*resultSet=[_fmdb executeQuery:sql];
    while ([resultSet next]) {
        MJKDataDicModel*model=[[MJKDataDicModel alloc]init];
        model.C_TYPECODE=[resultSet stringForColumn:@"C_TYPECODE"];
        model.C_FATHERVOUCHERID=[resultSet objectForColumn:@"C_TYPECODE"];
        model.C_ID=[resultSet stringForColumn:@"C_ID"];
        model.C_NAME=[resultSet stringForColumn:@"C_NAME"];
        model.FLAG=[resultSet stringForColumn:@"FLAG"];
        model.I_SORTIDX=[resultSet stringForColumn:@"I_SORTIDX"];
        model.C_VOUCHERID=[resultSet stringForColumn:@"C_VOUCHERID"];
        
        [dataArray addObject:model];
    }
    
    
    [_fmdb close];
    
    return dataArray;
    
    
}



-(void)addDataModel:(MJKDataDicModel*)model{
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO '%@' ('C_TYPECODE', 'C_FATHERVOUCHERID', 'C_ID', 'C_NAME',  'FLAG', 'I_SORTIDX', 'C_VOUCHERID') VALUES ('%@', '%@', '%@','%@', '%@', '%@', '%@');",KTableName, model.C_TYPECODE, model.C_FATHERVOUCHERID, model.C_ID,model.C_NAME,model.FLAG,model.I_SORTIDX,model.C_VOUCHERID];
    [self fmdbExecSql:sql];

    
}


-(void)deleteAllDataModel{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@;",KTableName];
    [self fmdbExecSql:sql];
}


-(void)deleteDataModel:(MJKDataDicModel*)model{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE C_ID='%@';",KTableName,model.C_ID];
    [self fmdbExecSql:sql];

    
}
-(void)updateDataModel:(MJKDataDicModel*)model{
    //先删除   后添加
    [self deleteDataModel:model];
    [self addDataModel:model];
    
    
}



#pragma mark - fmdb查询数据
-(NSMutableArray*)queryDatasWithC_TYPECODE:(NSString*)C_TYPECODE{
    NSString*sqlQuery=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE C_TYPECODE = '%@';",KTableName,C_TYPECODE];
    return [self queryNeedModelWithSql:sqlQuery];
}


-(NSMutableArray*)queryAllDatas{
    NSString*sqlQuery=[NSString stringWithFormat:@"SELECT * FROM %@;",KTableName];
    return [self queryNeedModelWithSql:sqlQuery];

}




@end
