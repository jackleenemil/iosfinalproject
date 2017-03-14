//
//  Exhibitors.h
//  MyProject
//
//  Created by JETS on 2/24/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Exhibitors : NSObject

@property NSString *idd;
@property NSString *address;
@property NSString *email;
@property NSString *country_name;
@property NSString *city_name;
@property NSString *comp_name;
@property NSMutableArray *phons;
@property NSMutableArray *mobiles;
@property NSString *about;
@property NSString *fax;
@property NSString *contact_name;
@property NSString *contact_title;
@property NSString *comp_url;
@property NSString *img_url;
@property NSData *img;

//@property    UIRefreshControl *refreshControl;


@end
