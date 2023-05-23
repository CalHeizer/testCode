//
//  ChatDetailViewController.h
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *dialogMessages;
@property(strong, nonatomic) UITextField *myTextField;
@property(strong, nonatomic) UIToolbar *myToolbar;
@property(strong, nonatomic) UIButton *myButton;
@property(strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
