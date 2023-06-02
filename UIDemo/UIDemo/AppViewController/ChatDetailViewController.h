//
//  ChatDetailViewController.h
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import <UIKit/UIKit.h>
#import "../Sqlite/SqliteHandle.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *dialogMessages;
@property(strong, nonatomic) UITextField *myTextField;
@property(strong, nonatomic) UIToolbar *myToolbar;
@property(strong, nonatomic) UIButton *myButton;
@property(strong, nonatomic) NSString *name;

@property(strong, nonatomic) NSString *rName;

@property(strong, nonatomic) NSMutableArray *listData;

@property(assign, nonatomic) NSInteger ID;

@property(assign, nonatomic) SqliteHandle *sqliteHandle;

@property(assign, nonatomic) NSInteger rID;

@property(assign, nonatomic) NSString *sqlPathName;



@end

NS_ASSUME_NONNULL_END
