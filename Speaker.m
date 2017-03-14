//
//  Speaker.m
//  MyProject
//
//  Created by JETS on 2/24/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "Speaker.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@implementation Speaker

-(id)init
{
    _idd=@"nel";
    _fName=@"nel";
    _lName=@"nel";
    _companyName=@"nel";
    _titlee=@"nel";
    _mobiles=[NSMutableArray new];
    _phones=[NSMutableArray new];
    [_mobiles arrayByAddingObject:@"nel"];
    [_phones arrayByAddingObject:@"nel"];
    _middleName=@"nel";
    _biography=@"nel";
    _imageURL=@"nel";
    _img=  UIImagePNGRepresentation([UIImage imageNamed:@"Speaker.png"]) ;
    _gender=@"nel";
    return self;
}

@end
