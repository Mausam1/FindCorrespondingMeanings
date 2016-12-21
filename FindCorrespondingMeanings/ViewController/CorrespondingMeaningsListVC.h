//
//  CorrespondingMeaningsListVC.h
//  FindCorrespondingMeanings
//
//  Created by Mausam on 12/20/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "WebService.h"
#import "MBProgressHUD.h"


@interface CorrespondingMeaningsListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
