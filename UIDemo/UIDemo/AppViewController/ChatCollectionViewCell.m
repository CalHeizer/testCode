//
//  ChatCollectionViewCell.m
//  UIDemo
//
//  Created by lyq on 2023/5/24.
//

#import "ChatCollectionViewCell.h"

@implementation ChatCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.imageView];
        
        
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 3;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.headImageView.image = nil;
    self.nameLabel.text = nil;
    self.textLabel.text = nil;
    self.imageView.image = nil;
    
}

- (void)layoutSubviews {
//    NSLog(@"[yql] layoutSubviews: %@", NSStringFromCGRect(self.contentView.frame));
//    NSLog(@"[yql] imageView: %@", NSStringFromCGRect(self.imageView.frame));
//    NSLog(@"[yql] headImageView: %@", NSStringFromCGRect(self.headImageView.frame));
//    NSLog(@"[yql] textLabel: %@", NSStringFromCGRect(self.textLabel.frame));
//    NSLog(@"[yql] nameLabel: %@", NSStringFromCGRect(self.nameLabel.frame));

}

- (void)updateDataName:(NSString *)name Text:(NSString *)text Picture:(NSString *)picName {
    self.nameLabel.text = name;
    self.headImageView.image = [UIImage imageNamed:name];
    self.headImageView.frame = CGRectMake(3, self.contentView.frame.size.height - 23, 20, 20);
    self.nameLabel.frame = CGRectMake(self.headImageView.frame.origin.x + 24, self.headImageView.frame.origin.y, self.contentView.frame.size.width - 27, 20);
    
    UIImage *image = [UIImage imageNamed:picName];
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = width / image.size.width * image.size.height;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, width, height);
    
    self.textLabel.text = text;
    self.textLabel.frame = CGRectMake(3, height + 3, width - 6, self.contentView.frame.size.height - height - 29);
    
}

@end
