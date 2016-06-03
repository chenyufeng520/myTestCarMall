//
//  User.h
//  BSports
//
//  Created by 高大鹏 on 15/10/5.
//  Copyright © 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *uid, *user_email, *user_nickname, *user_phone, *user_time, *user_username,*user_type;

@end
