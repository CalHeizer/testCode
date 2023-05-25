//
//  WorkViewController.m
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import "WorkViewController.h"
#import "ChatCollectionViewCell.h"
#import "CollectionWfLayout.h"


@interface WorkViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CollectionWfLayoutProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionWfLayout *waterfallLayout;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
    self.navigationItem.title = navigationController.tabBarItem.title;
    NSLog(@"%@", self.navigationItem.title);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataList = [NSMutableArray array];
    NSInteger dataCount = arc4random() % 25 + 50;
    for(NSInteger i = 0; i < dataCount; i++){
        NSInteger rowHeight = arc4random() % 100 + 200;
        [self.dataList addObject:@(rowHeight)];
    }
    
    [self.view addSubview:self.collectionView];
    
}

- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _waterfallLayout = [[CollectionWfLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = self.view.frame.size.width / 180  > 2 ? self.view.frame.size.width / 190 : 2;
        _waterfallLayout.columnSpacing = 10;
        _waterfallLayout.insets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"IDIDID"];
    }

    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IDIDID" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random()% 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return cell;
    
}

#pragma mark - CollectionWfLayoutProtocol

- (CGFloat)collectionViewLayout:(CollectionWfLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CGFloat cellHeight = [self.dataList[row] floatValue];
    return cellHeight;
}

- (CGFloat)collectionViewLayout:(CollectionWfLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"[yql] viewWillLayoutSubviews: %@", NSStringFromCGRect(self.view.frame));
    self.waterfallLayout.columns = self.view.frame.size.width / 180  > 2 ? self.view.frame.size.width / 190 : 2;
    
    
    
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    self.collectionView.frame = CGRectMake(safeAreaInsets.left, safeAreaInsets.top, self.view.frame.size.width - safeAreaInsets.left - safeAreaInsets.right,
                                           self.view.frame.size.height - safeAreaInsets.top - safeAreaInsets.bottom);
    
}

@end
