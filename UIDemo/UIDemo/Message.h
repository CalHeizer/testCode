//
//  Message.h
//  UIDemo
//
//  Created by lyq on 2023/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property(nonatomic, strong)NSString *message;
@property(nonatomic, assign)BOOL isMine;

@end

NS_ASSUME_NONNULL_END
