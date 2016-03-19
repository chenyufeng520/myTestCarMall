//
//  User.h
//  BSports
//
//  Created by 高大鹏 on 15/10/5.
//  Copyright © 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userid, *realname, *email, *phone, *nickname, *headimgurl, *address, *birthday, *statemsg, *vocation;
@property (nonatomic, assign) int gender, age;

@end
