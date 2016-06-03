//
//  User.m
//  BSports
//
//  Created by 高大鹏 on 15/10/5.
//  Copyright © 2015年 ist. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.user_email = [decoder decodeObjectForKey:@"user_email"];
        self.user_nickname = [decoder decodeObjectForKey:@"user_nickname"];
        self.user_phone = [decoder decodeObjectForKey:@"user_phone"];
        self.user_time = [decoder decodeObjectForKey:@"user_time"];
        self.user_username = [decoder decodeObjectForKey:@"user_username"];
        self.user_type = [decoder decodeObjectForKey:@"user_type"];
       
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.user_type forKey:@"user_type"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.user_email forKey:@"user_email"];
    [encoder encodeObject:self.user_nickname forKey:@"user_nickname"];
    [encoder encodeObject:self.user_phone forKey:@"user_phone"];
    [encoder encodeObject:self.user_time forKey:@"user_time"];
    [encoder encodeObject:self.user_username forKey:@"user_username"];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    User *nUser = [[User allocWithZone:zone] init];
    nUser.uid = self.uid;
    nUser.user_email = self.user_email;
    nUser.user_nickname = self.user_nickname;
    nUser.user_phone = self.user_phone;
    nUser.user_time = self.user_time;
    nUser.user_type = self.user_type;
    nUser.user_username = self.user_username;
    
    return nUser;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setNilValueForKey:(NSString *)key
{
    [super setNilValueForKey:key];
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"userid:%@,phone:%@",self.uid,self.user_phone];
    return descriptionString;
}

- (BOOL)isEqual:(id)object
{
    User *other = (User *)object;
    if (![self.uid isEqualToString:other.uid]) {
        return NO;
    }
    if (self.user_email &&![self.user_email isEqualToString:other.user_email]) {
        return NO;
    }
    if (self.user_nickname && ![self.user_nickname isEqualToString:other.user_nickname]) {
        return NO;
    }
    if (self.user_phone && ![self.user_phone isEqualToString:other.user_phone]) {
        return NO;
    }
    if (self.user_time && ![self.user_time isEqualToString:other.user_time]) {
        return NO;
    }
    if (self.user_username && ![self.user_username isEqualToString:other.user_username]) {
        return NO;
    }
    if (self.user_type && ![self.user_type isEqualToString:other.user_type]) {
        return NO;
    }
    return YES;
}

@end
