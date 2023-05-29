//
//  SceneDelegate.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "SceneDelegate.h"
#import "AppViewController/ChatViewController.h"
#import "AppViewController/AddBookViewController.h"
#import "AppViewController/DocViewController.h"
#import "AppViewController/WorkViewController.h"
#import "AppViewController/EmailViewController.h"

#import "AppViewController/ChatDetailViewController.h"

#import "Sqlite/SqliteHandle.h"

@interface SceneDelegate ()

@property (strong, nonatomic)UITabBarController* tabBarController;

@property (strong, nonatomic)NSString *sqlPathName;

@property (strong, nonatomic)SqliteHandle *sqliteHandle;

@property (strong, nonatomic)NSString *myName;

@end

@implementation SceneDelegate

- (NSString *)sqlPathName {
    if (!_sqlPathName) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _sqlPathName = [docPath stringByAppendingPathComponent:@"chat.sqlite"];
        NSLog(@"%@", _sqlPathName);
        
    }
    return _sqlPathName;
}

- (SqliteHandle *)sqliteHandle {
    if (!_sqliteHandle) {
        _sqliteHandle = [[SqliteHandle alloc] init];
    }
    return _sqliteHandle;
}


- (void) initSqlDataBase {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user (user_id INTEGER PRIMARY KEY, user_name TEXT, image TEXT);";
//    [self.sqliteHandle createSqlDataBase:self.sqlPathName SqlSent:sql];
//    sql = @"CREATE TABLE IF NOT EXISTS message (message_id INTEGER PRIMARY KEY, sender_id INTEGER REFERENCES user(user_id), receiver_id INTEGER REFERENCES user(user_id), message_type TEXT, message_body BLOB, timestamp INTEGER DEFAULT (strftime('%s', 'now')));";
//    [self.sqliteHandle createSqlDataBase:self.sqlPathName SqlSent:sql];
//
//    sql = @"INSERT INTO user (user_name, image) VALUES ('小强', '小强')";
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
//    sql = @"INSERT INTO user (user_name, image) VALUES ('小红', '小红')";
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
//    sql = @"INSERT INTO user (user_name, image) VALUES ('张三', '张三')";
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
//    sql = @"INSERT INTO user (user_name, image) VALUES ('小明', '小明')";
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
//    sql = @"INSERT INTO user (user_name, image) VALUES ('爱丽丝', '爱丽丝')";
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
        
    NSDictionary *dict = @{@"text" : @"兄弟在不在"};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&error];
//    const void *bytes = [data bytes];
//    NSUInteger length = [data length];
//    NSMutableString *str = [[NSMutableString alloc] initWithString:@"0x"];
//    for (NSUInteger i = 0; i<length; ++i) {
//        uint8_t byte = *((uint8_t *)bytes + i);
//        [str appendFormat:@"%x",byte];
//    }
    
    
    sql = [NSString stringWithFormat:@"INSERT INTO message (sender_id, receiver_id, message_type, message_body) VALUES (%d, %d, '%@', ?);",3,1,@"text"];
//    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql];
    [self.sqliteHandle insertSqlDataBase:self.sqlPathName SqlSent:sql NSData:data Index:4];
    
    
    
    sql = @"SELECT * FROM message WHERE sender_id = (SELECT user_id FROM user WHERE user_id = 3) AND receiver_id = (SELECT user_id FROM user WHERE user_id = 1);";
    id message = [self.sqliteHandle selectSqlDataBase:self.sqlPathName SqlSent:sql];
    if (message != nil) {
        NSMutableArray *array = (NSMutableArray *)message;
        for (NSDictionary *dict in array) {
            NSData *ddd = dict[@"message_body"];
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:ddd options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"%@", dd[@"text"]);
        }
    }
}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
//    [self initSqlDataBase];
    self.myName = @"小强";
    
    
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.sqlPathName = self.sqlPathName;
    chatViewController.sqliteHandle = self.sqliteHandle;
    chatViewController.myName = self.myName;
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    navigationController1.tabBarItem.title = @"聊天";
    navigationController1.tabBarItem.image = [UIImage imageNamed:@"chat"];
    
    AddBookViewController *addBookViewController = [[AddBookViewController alloc] init];
    addBookViewController.sqlPathName = self.sqlPathName;
    addBookViewController.sqliteHandle = self.sqliteHandle;
    addBookViewController.myName = self.myName;
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:addBookViewController];
    navigationController2.tabBarItem.title = @"通信录";
    navigationController2.tabBarItem.image = [UIImage imageNamed:@"addressbook"];
    
    
    DocViewController *docViewController = [[DocViewController alloc] init];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:docViewController];
    navigationController3.tabBarItem.title = @"文档";
    navigationController3.tabBarItem.image = [UIImage imageNamed:@"document"];
    
    WorkViewController *workViewController = [[WorkViewController alloc] init];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:workViewController];
    navigationController4.tabBarItem.title = @"聊天框";
    navigationController4.tabBarItem.image = [UIImage imageNamed:@"workbench"];
    
    EmailViewController *emailViewController = [[EmailViewController alloc] init];
    UINavigationController *navigationController5 = [[UINavigationController alloc] initWithRootViewController:emailViewController];
    navigationController5.tabBarItem.title = @"邮件";
    navigationController5.tabBarItem.image = [UIImage imageNamed:@"email"];
    
    self.tabBarController.viewControllers = @[
        navigationController1,
        navigationController2,
        navigationController3,
        navigationController4,
        navigationController5
    ];
    
    
    self.window.rootViewController = self.tabBarController;

}



- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
