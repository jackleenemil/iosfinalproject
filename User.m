//
//  User.m
//  MyProject
//
//  Created by JETS on 2/24/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "User.h"

@implementation User


+(User*)sharedInstance{
    static User *d=nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once,^{
        d=[[User alloc] init];
    });
    
    return d;
    
    
}

-(id)init{
    _idd=@"nel";
    _code=@"nel";
    _birthDate=@"nel";
    _email=@"nel";
    _firstName=@"nel";
    _lastName=@"nel";
    _country_name=@"nel";
    _city_name=@"nel";
    _comp_name=@"nel";
    _titlee=@"nel";
    _phones=[NSMutableArray new];
    _mobiles=[NSMutableArray new];
    [_phones addObject:@"nel"];
    [_mobiles addObject:@"nel"];
    _midName=@"nel";
    _gender=@"nel";
    _img_url=@"nel";
    _img= [@"nel" dataUsingEncoding:NSUTF8StringEncoding];
    return self;
}
@end
