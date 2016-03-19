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
        self.userid = [decoder decodeObjectForKey:@"userid"];
        self.realname = [decoder decodeObjectForKey:@"realname"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.headimgurl = [decoder decodeObjectForKey:@"headimgurl"];
        self.vocation = [decoder decodeObjectForKey:@"vocation"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.statemsg = [decoder decodeObjectForKey:@"statemsg"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.gender = [[decoder decodeObjectForKey:@"gender"] intValue];
        self.age = [[decoder decodeObjectForKey:@"age"] intValue];
       
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [encoder encodeObject:[NSNumber numberWithInt:self.age] forKey:@"age"];
    [encoder encodeObject:self.vocation forKey:@"vocation"];
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.realname forKey:@"realname"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.headimgurl forKey:@"headimgurl"];
    [encoder encodeObject:self.statemsg forKey:@"statemsg"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    User *nUser = [[User allocWithZone:zone] init];
    nUser.userid = self.userid;
    nUser.realname = self.realname;
    nUser.email = self.email;
    nUser.phone = self.phone;
    nUser.nickname = self.nickname;
    nUser.headimgurl = self.headimgurl;
    nUser.address = self.address;
    nUser.birthday = self.birthday;
    nUser.statemsg = self.statemsg;
    nUser.vocation = self.vocation;
    nUser.gender = self.gender;
    nUser.age = self.age;
    
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
    NSString *descriptionString = [NSString stringWithFormat:@"userid:%@,phone:%@",self.userid,self.phone];
    return descriptionString;
}

- (BOOL)isEqual:(id)object
{
    User *other = (User *)object;
    if (![self.userid isEqualToString:other.userid]) {
        return NO;
    }
    if (self.nickname &&![self.nickname isEqualToString:other.nickname]) {
        return NO;
    }
    if (self.address && ![self.address isEqualToString:other.address]) {
        return NO;
    }
    if (self.birthday && ![self.birthday isEqualToString:other.birthday]) {
        return NO;
    }
    if (self.statemsg && ![self.statemsg isEqualToString:other.statemsg]) {
        return NO;
    }
    if (self.vocation && ![self.vocation isEqualToString:other.vocation]) {
        return NO;
    }
    if (self.gender != other.gender) {
        return NO;
    }
    if (self.age != other.age) {
        return NO;
    }
    
    return YES;
}

@end
