//
//  Exhibitors.m
//  MyProject
//
//  Created by JETS on 2/24/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "Exhibitors.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>


@implementation Exhibitors
-(id)init
{
    _idd=@"nel";
    _address=@"nel";
    _email=@"nel";
    _country_name=@"nel";
    _city_name=@"nel";
    _comp_name=@"nel";
    _phons=[NSMutableArray new];
    _mobiles=[NSMutableArray new];
    [_phons addObject: @"nel"];
    [_mobiles addObject: @"nel"];
    _about=@"nel";
    _fax=@"nel";
    _contact_name=@"nel";
    _contact_title=@"nel";
    _comp_url=@"nel";
    _img_url=@"nel";
    _img= UIImagePNGRepresentation([UIImage imageNamed:@"exihiptors.png"]) ;

    
    return self;
}
@end
