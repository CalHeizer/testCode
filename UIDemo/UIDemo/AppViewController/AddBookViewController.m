//
//  AddBookViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "AddBookViewController.h"
#import "ChatDetailViewController.h"

@interface AddBookViewController ()

@property(strong, nonatomic) NSMutableArray *listData;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
    self.navigationItem.title = navigationController.tabBarItem.title;
    

    self.listData = [[NSMutableArray alloc] init];
    NSString *sql = @"SELECT * FROM user;";
    id sqlArray = [self.sqliteHandle selectSqlDataBase:self.sqlPathName SqlSent:sql];
    if (sqlArray != nil) {
        NSMutableArray *array = (NSMutableArray *)sqlArray;
        for (NSDictionary *dict in array) {
            NSNumber *temp = dict[@"user_id"];
            NSString *name = dict[@"user_name"];
            if ([name isEqualToString:self.myName]) {
                self.my_id = temp;
            }
            NSDictionary *userDict = @{@"name": name, @"rid": temp};
            [self.listData addObject:userDict];
        }
    }
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark --实现表视图数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSDictionary *dict = self.listData[row];
    cell.textLabel.text = dict[@"name"];
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
    detailViewController.ID = [self.my_id integerValue];
    detailViewController.rID = [dict[@"rid"] integerValue];
    detailViewController.sqliteHandle = self.sqliteHandle;
    detailViewController.sqlPathName = self.sqlPathName;
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
