//
//  CorrespondingMeaningsListVC.m
//  FindCorrespondingMeanings
//
//  Created by Mausam on 12/20/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

#import "CorrespondingMeaningsListVC.h"

@interface CorrespondingMeaningsListVC(){
    UIAlertController *alertGetInput;
    NSArray *arrayListOfMeanings;
}
@end

@implementation CorrespondingMeaningsListVC

#pragma View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    arrayListOfMeanings = [[NSArray alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Enter"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(findCorrespondingMeaningAlertController)];
    [item setTintColor:[UIColor blackColor]];
    [[self navigationItem] setRightBarButtonItem:item];
    self.title = @"(Please click on Enter)";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self.navigationController.navigationBar setTranslucent:false];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBarTintColor:[UIColor lightGrayColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOptions];
    
    if (arrayListOfMeanings.count == 1) {
        self.title = @"(Please click on Enter)";
    }
}

#pragma tableview delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayListOfMeanings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [[arrayListOfMeanings objectAtIndex:indexPath.row] valueForKey:@"lf"];
    return cell;
}

#pragma Call webservice

-(void)callWebServiceToFindCorrespondingMeanings:(NSString*)inputText{
    if ([self isConnectedToTheInternet]) {
        
        [WebService getListOfCorrespondingMeanings:inputText andCompletionHandler:^(NSArray *resultArray, bool resultStatus) {
            if (resultStatus) {
                if (resultArray.count > 0) {
                    arrayListOfMeanings = [[resultArray objectAtIndex:0] valueForKey:@"lfs"];
                    NSLog(@"Response Data For input(%@) :  %@",inputText,arrayListOfMeanings);
                    self.title = inputText;
                    [_mainTableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }
                else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self otherAlertController:@"No Match" message:[NSString stringWithFormat:@"Sorry there is no corresponding meanings to your input(%@).  Please try again with other input",inputText]];
                }
            }
            else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self otherAlertController:@"Oops" message:[NSString stringWithFormat:@"Got error while looking for conrresponding meanings for your input(%@).  Please try again",inputText]];
            }
        }];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self otherAlertController:@"No Internet" message:@"Please connect to the internet and try again"];
    }
}

#pragma UI Components

-(void)findCorrespondingMeaningAlertController{
    if ([self isConnectedToTheInternet]) {
        
        alertGetInput = [UIAlertController alertControllerWithTitle:@"Find Corresponding Meanings" message:@""preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof__(self) weakSelf = self;
        
        [alertGetInput addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"enter an acronym or initialism";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            [textField becomeFirstResponder];
            textField.delegate = weakSelf;
            textField.tag = 1;
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        UIAlertAction* findButton = [UIAlertAction
                                     actionWithTitle:@"Find"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self findButtonPressed];
                                         
                                     }];
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [self cancelButtonPressed];
                                       }];
        
        [alertGetInput addAction:findButton];
        [alertGetInput addAction:cancelButton];
        
        [self presentViewController:alertGetInput animated:YES completion:nil];
    }
    else{
        [self otherAlertController:@"No Internet" message:@"Please connect to the internet and try again"];
    }
    
}

- (void)cancelButtonPressed{
    [alertGetInput dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)findButtonPressed{
    NSLog(@"Entered text: %@",alertGetInput.textFields[0].text);
    if (![alertGetInput.textFields[0].text  isEqual: @""]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self cancelButtonPressed];
        [self callWebServiceToFindCorrespondingMeanings:alertGetInput.textFields[0].text];
    }
    else{
        [self cancelButtonPressed];
        [self performSelector:@selector(findCorrespondingMeaningAlertController) withObject:nil afterDelay:0.1];
    }
}

-(void)otherAlertController:(NSString*)title message:(NSString*)message{
    if (arrayListOfMeanings.count>0) {
        arrayListOfMeanings = nil;
        arrayListOfMeanings = [[NSArray alloc] init];
        [_mainTableView reloadData];
        self.title = @"(Please click on Enter)";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Okay"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:^{
                                       }];
                                   }];
    
    [alertController addAction:cancelButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(bool)isConnectedToTheInternet{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        return YES;
    }
    else if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown) {
        return NO;
    }
    else
        return NO;
}

#pragma UITextfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self findButtonPressed];
    return YES;
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
