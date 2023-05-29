//
//  SqliteHandle.m
//  UIDemo
//
//  Created by lyq on 2023/5/26.
//

#import "SqliteHandle.h"
#import "sqlite3.h"

@interface SqliteHandle () {
    sqlite3 *_db;
}

//@property (nonatomic, strong) NSString *sqlName;
//
//@property (nonatomic, strong) NSString *docPath;
//
//@property (nonatomic, strong) NSString *fileName;

@end

@implementation SqliteHandle

//- (instancetype) init {
//    if (self = [super init]) {
//        self.docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////        self.fileName = [self.docPath stringByAppendingPathComponent:@"default_db.sqlite"];
//        self.sqlName = @"default_db.sqlite";
//        self.fileName = [self.docPath stringByAppendingPathComponent:self.sqlName];
//    }
//    return self;
//}
//
//
//- (instancetype) initWithDocPath:(NSString *)docPath SqlName:(NSString *)sqlName {
//    if (self = [super init]) {
//        self.docPath = docPath;
//        self.sqlName = sqlName;
//        self.fileName = [self.docPath stringByAppendingPathComponent:self.sqlName];
//    }
//    return self;
//}
//
//
//- (int) openSqlDataBase {
//    const char *cFilename = self.fileName.UTF8String;
//    int result = sqlite3_open(cFilename, &_db);
//    if (result != SQLITE_OK) {
//        NSLog(@"打开数据库失败");
//    } else {
//        NSLog(@"打开数据库成功");
//    }
//    return result;
//}

- (int) openSqlDataBase:(NSString *)fileName {
    const char *cFileName = fileName.UTF8String;
    
    return [self openSqlDataBaseC:cFileName];
}

- (int) openSqlDataBaseC:(const char *)cFlieName {
    int result = sqlite3_open(cFlieName, &_db);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
    } else {
        NSLog(@"打开数据库成功");
    }
    return result;
}

- (int) createSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent {
    int result = [self openSqlDataBase:fileName];
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return result;
    }
    const char *sql = sqlSent.UTF8String;
    char *errMsg = NULL;
    result = sqlite3_exec(_db, sql, NULL, NULL, &errMsg);
    
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
        printf("创建失败---%s---%s---%d \n", errMsg, __FILE__, __LINE__);
    }
    return result;
}


- (int) insertSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent {
    int result = [self openSqlDataBase:fileName];
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return result;
    }
    const char *sql = sqlSent.UTF8String;
    char *errMsg = NULL;
    result = sqlite3_exec(_db, sql, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
        printf("插入数据失败---%s---%s---%d \n", errMsg, __FILE__, __LINE__);
    }
    return result;
}

- (int) insertSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent NSData:(NSData *)data Index:(int)index {
    int result = [self openSqlDataBase:fileName];
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return result;
    }
    const char *sql = sqlSent.UTF8String;
    sqlite3_stmt *stmt = NULL;
    result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"插入语句错误");
        return result;
    }
    result = sqlite3_bind_blob(stmt, 1, [data bytes], (int)[data length], SQLITE_TRANSIENT);
    if (result != SQLITE_OK) {
        NSLog(@"绑定BLOB错误: %s", sqlite3_errmsg(_db));
        sqlite3_finalize(stmt);
        return result;
    }
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"执行错误: %s", sqlite3_errmsg(_db));
    }
    sqlite3_finalize(stmt);
    return result;
}

- (id) selectSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent {
    int result = [self openSqlDataBase:fileName];
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return nil;
    }
    const char *sql = sqlSent.UTF8String;
    sqlite3_stmt *stmt = NULL;
    
    result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句没有问题");
        int columnCount = sqlite3_column_count(stmt);
        NSMutableArray *res = [NSMutableArray array];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *row = [NSMutableDictionary dictionary];
            for (int i = 0; i < columnCount; ++i) {
                const char *name = sqlite3_column_name(stmt, i);
                int type = sqlite3_column_type(stmt, i);
                id value = nil;
                switch (type) {
                    case SQLITE_INTEGER:
                        value = [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, i)];
                        break;
                    case SQLITE_FLOAT:
                        value = [NSNumber numberWithDouble:sqlite3_column_double(stmt, i)];
                        break;
                    case SQLITE_TEXT:
                        value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                        break;
                    case SQLITE_BLOB:
                        value = [NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
                        break;
                    case SQLITE_NULL:
                        value = [NSNull null];
                        break;
                    default:
                        break;
                }
                [row setObject:value forKey:[NSString stringWithUTF8String:name]];
            }
            [res addObject:row];
        }
        sqlite3_finalize(stmt);
        return res;
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"查询语句有问题");
        return nil;
    }
}


@end
