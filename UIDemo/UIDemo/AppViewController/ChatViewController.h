//
//  ChatViewController.h
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import <UIKit/UIKit.h>
#import "ChatDetailViewController.h"
#import "../Sqlite/SqliteHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UITableViewController

@property (nonatomic, strong) NSString *sqlPathName;
@property (nonatomic, strong) SqliteHandle *sqliteHandle;
@property (nonatomic, strong) NSString *myName;

@end

NS_ASSUME_NONNULL_END
