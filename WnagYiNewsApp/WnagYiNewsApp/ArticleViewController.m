//
//  ArticleViewController.m
//  WnagYiNewsApp
//
//  Created by Fidele on 7/7/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import "ArticleViewController.h"
#import "AFNetworking.h"

@interface ArticleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textbody;

@end

@implementation ArticleViewController

@synthesize articleId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.articleId];
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[self.webView loadRequest:request];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = [responseObject objectForKey: [NSString stringWithFormat:@"%@",self.articleId]];
        NSString *body = [response objectForKey:@"body"];
        self.textbody.text = body;
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Failure");
    }];
    
    [operation start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
