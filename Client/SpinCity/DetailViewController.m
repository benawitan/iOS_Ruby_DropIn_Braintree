//
//  DetailViewController.m
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import "DetailViewController.h"
#import <Braintree/Braintree.h>
#import "AFNetworking.h"


@interface DetailViewController () <BTDropInViewControllerDelegate>
@property (nonatomic, strong)  Braintree  *braintree;
@property (nonatomic, strong) NSString *clientToken;
@property (nonatomic, strong) NSString *nonce;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView{
    
    if (self.detailItem) {
        self.albumTitleLabel.text = [self.detailItem valueForKey:@"title"];
        self.priceLabel.text = [NSString stringWithFormat:@"$%01.2f", [[self.detailItem valueForKey:@"price"] floatValue]];
        self.artistLabel.text =[self.detailItem valueForKey:@"artist"];
        self.locationLabel.text = [self.detailItem valueForKey:@"locationInStore"];
        self.descriptionTextLabel.text = [self.detailItem valueForKey:@"summary"];
    }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
  
   if (!self.braintree){

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://localhost:4567/client_token"
      parameters:NULL
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // Setup braintree with responseObject[@"client_token"]
             self.clientToken = responseObject[@"client_token"];
             // Create and retain a `Braintree` instance with the client token
             self.braintree = [Braintree braintreeWithClientToken:self.clientToken];
             NSLog(@"%@", responseObject[@"client_token"]);

         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // Handle failure communicating with your server
             NSLog(@"Client Token Failure");

         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buyAction:(id)sender{
    [self tappedMyPayButton];
}

//BT Drop-in Payment UI. Only in English for now

- (void)tappedMyPayButton {

    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     target:self action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    self.nonce = paymentMethod.nonce;
    [self postNonceToServer:self.nonce]; // Send payment method nonce to your server
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)postNonceToServer:(NSString *)paymentMethodNonce
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://localhost:4567/simple_transaction"
       parameters:@{@"payment_method_nonce": self.nonce,@"price": [self.detailItem valueForKey:@"price"], @"customer_id":[[NSUUID UUID] UUIDString]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *jsonDict = (NSDictionary *) responseObject;
              if([jsonDict objectForKey:@"message"]){
                  // Handle failure
                  NSLog(@"Transaction Failled. %@",responseObject[@"message"]);
              }
              else{
                   // Handle success
                  NSLog(@"Transaction ID: %@ and Status: %@",[jsonDict objectForKey:@"@id"],[jsonDict objectForKey:@"@status"]);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // Handle failure communicating with your server
              NSLog(@"Failure! %@", error);
          }];
}

@end
