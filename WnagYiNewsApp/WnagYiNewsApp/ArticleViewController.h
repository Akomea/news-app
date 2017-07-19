//
//  ArticleViewController.h
//  WnagYiNewsApp
//
//  Created by Fidele on 7/7/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString *articleId;

@end
