//
//  UILabel+HTML.m
//  TestNetworkingWithImages
//
//  Created by JETS on 3/1/16.
//  Copyright (c) 2016 JETS. All rights reserved.
//

#import "UILabel+HTML.h"

@implementation UILabel (HTML)

- (void) setHtml: (NSString*) html
{
    NSError *err = nil;
    self.attributedText =
    [[NSAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}



@end
