//
//  ChatViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "ChatViewController.h"
#import "ChatDetailViewController.h"
#import "../Sqlite/SqliteHandle.h"

@interface ChatViewController ()

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSDictionary *dictData;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Chat" ofType:@"plist"];
    
    self.dictData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
    NSString *fun = navigationController.tabBarItem.title;
    
    NSLog(@"%@", fun);
    
}

- (NSString *)jsonSerialization:(NSDictionary *)dict {
    // 不同的类型 dict[@"message_type"] 不同的处理方式
    NSData *data = dict[@"message_body"];
    NSDictionary *ddd = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return ddd[@"text"];
}

- (void)loadListData {
    if (!_listData)
        _listData = [[NSMutableArray alloc] init];
    NSString *sql = @"SELECT * FROM user;";
    id sqlArray = [self.sqliteHandle selectSqlDataBase:self.sqlPathName SqlSent:sql];
    if (sqlArray != nil) {
        NSNumber *my_id = nil;
        NSMutableArray *array = (NSMutableArray *)sqlArray;
        for (NSDictionary *dict in array) {
            NSNumber *temp = dict[@"user_id"];
            NSString *name = dict[@"user_name"];
            NSInteger ids = [temp integerValue];
            if ([name isEqualToString:self.myName]) {
                // 如果是自己对自己发
                my_id = temp;
                sql = [[NSString alloc] initWithFormat:@"SELECT sender_id,receiver_id,message_type,message_body FROM message WHERE sender_id = %ld AND receiver_id = %ld ORDER BY timestamp DESC LIMIT 1;", ids, ids];
                
            } else
                // 否者 使用 OR 会出现错误
                sql = [[NSString alloc] initWithFormat:@"SELECT sender_id,receiver_id,message_type,message_body FROM message WHERE sender_id = %ld OR receiver_id = %ld ORDER BY timestamp DESC LIMIT 1;", ids, ids];
            sqlArray = [self.sqliteHandle selectSqlDataBase:self.sqlPathName SqlSent:sql];
            if (sqlArray != nil) {
                NSMutableArray *sql2Array = (NSMutableArray *)sqlArray;
                if (sql2Array.count == 0) continue;
                NSDictionary *dict = [sql2Array lastObject];
                NSNumber *sender_id = dict[@"sender_id"];
                NSNumber *receiver_id = dict[@"receiver_id"];
                NSString *chat = [self jsonSerialization:dict];
                
                
                if ([sender_id isEqualToNumber:my_id]) {
                    NSDictionary *data = @{@"name" : name, @"id" : sender_id, @"rid" : receiver_id, @"chat" : chat};
                    NSMutableDictionary *ddata = [[NSMutableDictionary alloc] initWithDictionary:data];
                    [_listData addObject:ddata];
                } else {
                    NSDictionary *data = @{@"name" : name, @"id" : receiver_id, @"rid" : sender_id, @"chat" : chat};
                    NSMutableDictionary *ddata = [[NSMutableDictionary alloc] initWithDictionary:data];

                    [_listData addObject:ddata];
                }
                    
            }
        }
    }
}
//SELECT message_type,message_body FROM message WHERE sender_id = 1 OR receiver_id = 1 ORDER BY timestamp DESC LIMIT 1
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listData removeAllObjects];
    [self loadListData];
    [self.tableView reloadData];
}

#pragma mark --实现表视图数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSDictionary *dict = self.listData[row];
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"chat"];
    cell.imageView.image = [UIImage imageNamed:dict[@"name"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

#pragma mark --实现表视图委托协议方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger selectedIndex = [indexPath row];
    NSDictionary *dict = self.listData[selectedIndex];
    
    ChatDetailViewController *detailViewController = [[ChatDetailViewController alloc] init];
    detailViewController.name = dict[@"name"];
    detailViewController.ID = [dict[@"id"] integerValue];
    detailViewController.rID = [dict[@"rid"] integerValue];
    detailViewController.sqliteHandle = self.sqliteHandle;
    detailViewController.sqlPathName = self.sqlPathName;
    detailViewController.hidesBottomBarWhenPushed = YES;
    detailViewController.listData = self.listData;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


@end
