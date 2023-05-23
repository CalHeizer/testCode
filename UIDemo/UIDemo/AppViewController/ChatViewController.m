//
//  ChatViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "ChatViewController.h"
#import "ChatDetailViewController.h"

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
    
    NSString *userPath = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"];
    NSArray *userInfo = [[NSArray alloc] initWithContentsOfFile:userPath];
    self.listData = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in userInfo) {
        NSString *strName = dict[@"name"];
        NSArray *chatArray = self.dictData[strName];
        NSString *chat = [chatArray lastObject][@"msg"] ;
        NSDictionary *data = @{@"name" : strName, @"chat" : chat};
        [self.listData addObject:data];
    }
    self.navigationItem.title = navigationController.tabBarItem.title;
    
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
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


@end
