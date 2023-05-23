//
//  EmailViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "EmailViewController.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
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

@end
