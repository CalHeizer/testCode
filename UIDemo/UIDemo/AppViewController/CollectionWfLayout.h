//
//  CollectionWfLayout.h
//  UIDemo
//
//  Created by lyq on 2023/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionWfLayoutProtocol;

@interface CollectionWfLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CollectionWfLayoutProtocol> delegate;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;

@end



@protocol CollectionWfLayoutProtocol <NSObject>

- (CGFloat)collectionViewLayout:(CollectionWfLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)collectionViewLayout:(CollectionWfLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
