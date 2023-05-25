//
//  ChatCollectionViewCell.h
//  UIDemo
//
//  Created by lyq on 2023/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *headImageView;

- (void)updateDataName:(NSString *)name Text:(NSString *)text Picture:(NSString *)picName;

@end

NS_ASSUME_NONNULL_END
