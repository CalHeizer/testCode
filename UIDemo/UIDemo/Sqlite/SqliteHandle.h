//
//  SqliteHandle.h
//  UIDemo
//
//  Created by lyq on 2023/5/26.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface SqliteHandle : NSObject

- (int) openSqlDataBase:(NSString *)fileName;

- (int) createSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent;

- (int) insertSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent;

- (id) selectSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent;

- (int) insertSqlDataBase:(NSString *)fileName SqlSent:(NSString *)sqlSent NSData:(NSData *)data Index:(int)index;


@end

NS_ASSUME_NONNULL_END
