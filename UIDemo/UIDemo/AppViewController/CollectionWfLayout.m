//
//  CollectionWfLayout.m
//  UIDemo
//
//  Created by lyq on 2023/5/25.
//

#import "CollectionWfLayout.h"

NSString *SupplementaryViewKindHeader = @"Header";
CGFloat SupplementaryViewKindHeaderPinnedHeight = 44.0;


@interface CollectionWfLayout ()

/** 保存所有Item的LayoutAttributes */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
/** 保存所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;

@end

@implementation CollectionWfLayout

- (instancetype)init {
    if(self = [super init]) {
        _columns = 1;
        _columnSpacing = 10;
        _itemSpacing = 10;
        _insets = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - UICollectionViewLayout
/**
 *  collectionView初次显示后会调用此方法 触发此方法会重新计算布局，每次布局也是从此方法开始
 *  在此方法中需要做的事情计算出后面的ContentSize和每个item的layoutAttributes
 */

- (void)prepareLayout {
    [super prepareLayout];
    
    //初始化数组
    self.columnHeights = [NSMutableArray array];
    for(NSInteger column=0; column < self.columns; column++){
        self.columnHeights[column] = @(0);
    }
    
    self.attributesArray = [NSMutableArray array];
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section=0; section<numSections; section++){
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item=0; item<numItems; item++){
            //遍历每一项
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //计算LayoutAttributes
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:attributes];
        }
    }
}


/**
 *  需要返回所有内容的滚动长度
 */
- (CGSize)collectionViewContentSize {
    NSInteger mostColumn = [self columnOfMostHeight];
    //所有列当中最大的高度
    CGFloat mostHeight = [self.columnHeights[mostColumn] floatValue];
    return CGSizeMake(self.collectionView.bounds.size.width, mostHeight + self.insets.top + self.insets.bottom);
}


/**
 *  当CollectionView开始刷新后，会调用此方法并传递rect参数
 *  需要利用rect参数判断出在当前可视区域中有哪几个indexPath会被显示 计算相关indexPath的layoutAttributes，加入数组中并返回
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = self.attributesArray;
    NSArray<NSIndexPath *> *indexPaths;
    //1、计算rect中出现的items
    indexPaths = [self indexPathForItemsInRect:rect];
    for(NSIndexPath *indexPath in indexPaths){
        //计算对应的LayoutAttributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    
    //2、计算rect中出现的SupplementaryViews
    //计算SupplementaryViewKindHeader
    indexPaths = [self indexPathForSupplementaryViewsOfKind:SupplementaryViewKindHeader InRect:rect];
    for(NSIndexPath *indexPath in indexPaths) {
        //计算对应的LayoutAttributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:SupplementaryViewKindHeader atIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    
    return attributesArray;
}



/**
 *
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
//    return YES;
}
#pragma mark - 计算单个indexPath的LayoutAttributes
/**
 *  根据indexPath，计算对应的LayoutAttributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //Item高度
    CGFloat itemHeight = 0;
    if ( self.delegate != nil ) {
        if ([self.delegate respondsToSelector:@selector(collectionViewLayout:heightForItemAtIndexPath:)] ) {
            itemHeight = [self.delegate collectionViewLayout:self heightForItemAtIndexPath:indexPath];
        } else {
            NSAssert(NO, @"delegate no complete");
        }
    }
    
    //headerView高度
    CGFloat headerHeight = 0;
    if ( self.delegate != nil ) {
        if ([self.delegate respondsToSelector:@selector(collectionViewLayout:heightForSupplementaryViewAtIndexPath:)]) {
            headerHeight = [self.delegate collectionViewLayout:self heightForSupplementaryViewAtIndexPath:indexPath];
        } else {
            NSAssert(NO, @"delegate no complete");
        }
    }
    
    //找出所有列中高度最小的
    NSInteger columnIndex = [self columnOfLessHeight];
    CGFloat lessHeight = [self.columnHeights[columnIndex] floatValue];
    
    //计算LayoutAttributes
    CGFloat width = (self.collectionView.frame.size.width - (self.insets.left + self.insets.right) - self.columnSpacing * (self.columns - 1)) / self.columns;
    CGFloat height = itemHeight;
    CGFloat x = self.insets.left + (width + self.columnSpacing) * columnIndex;
    CGFloat y = lessHeight==0 ? headerHeight + self.insets.top : lessHeight + self.itemSpacing;
    attributes.frame = CGRectMake(x, y, width, height);
    
    //更新列高度
    self.columnHeights[columnIndex] = @(y + height);
    
    return attributes;
}

/**
 *  根据kind、indexPath，计算对应的LayoutAttributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    //计算LayoutAttributes
    if([elementKind isEqualToString:SupplementaryViewKindHeader]){
        CGFloat width = self.collectionView.frame.size.width;
        CGFloat height = [self.delegate collectionViewLayout:self heightForSupplementaryViewAtIndexPath:indexPath];
        CGFloat x = 0;
        CGFloat offsetY = self.collectionView.contentOffset.y;
        CGFloat y = MAX(0, offsetY - (height - SupplementaryViewKindHeaderPinnedHeight));
        attributes.frame = CGRectMake(x, y, width, height);
        attributes.zIndex = 1024;
    }
    return attributes;
}


#pragma mark - helpers
/**
 *  找到高度最小的那一列的下标
 */
- (NSInteger)columnOfLessHeight {
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1){
        return 0;
    }

    __block NSInteger leastIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        if([number floatValue] < [self.columnHeights[leastIndex] floatValue]){
            leastIndex = idx;
        }
    }];
    
    return leastIndex;
}

/**
 *  找到高度最大的那一列的下标
 */
- (NSInteger)columnOfMostHeight {
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1) {
        return 0;
    }
    
    __block NSInteger mostIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        if([number floatValue] > [self.columnHeights[mostIndex] floatValue]){
            mostIndex = idx;
        }
    }];
    
    return mostIndex;
}

#pragma mark - 根据rect返回应该出现的Items
/**
 *  计算目标rect中含有的item
 */
- (NSMutableArray<NSIndexPath *> *)indexPathForItemsInRect:(CGRect)rect {
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    
    /**
     * 待完成
     */
    
    return indexPaths;
}

/**
 *  计算目标rect中含有的某类SupplementaryView
 */
- (NSMutableArray<NSIndexPath *> *)indexPathForSupplementaryViewsOfKind:(NSString *)kind InRect:(CGRect)rect {
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    /**
     
     */
    
    if([kind isEqualToString:SupplementaryViewKindHeader]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}


@end
