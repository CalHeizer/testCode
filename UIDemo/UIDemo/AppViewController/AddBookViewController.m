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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"];
    
    NSArray *userInfo = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    self.listData = [[NSMutableArray alloc] initWithArray:userInfo];
    
    
    

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
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
