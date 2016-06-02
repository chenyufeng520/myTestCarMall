//
//  ModifyUserInfoViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/6/2.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ModifyUserInfoViewController.h"
#import "User.h"
#import "MineDataHelper.h"
#import "MineProfileCell.h"
#import "MineProfileImgCell.h"

@interface ModifyUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
}


@end

@implementation ModifyUserInfoViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"编辑资料" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [tbTop setRightTitle:@"保存"];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    _contentView.height += kTabBarHeight;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _contentView.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];

}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==1) {
        return 4;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 100;
    }
    else{
        return 50;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArr = @[@"地址",@"呢称",@"手机号",@"邮箱"];
    NSArray *detailArr = @[@"暂无地址",@"呢称可以修改",@"18501047155",@"请输入邮箱地址"];
    if (indexPath.section ==0) {
        static NSString *imgCell = @"iden";
        MineProfileImgCell *cell = [tableView dequeueReusableCellWithIdentifier:imgCell];
        if (cell == nil) {
            cell = [[MineProfileImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgCell];
        }
        cell.largeImg.tag = 2015;
        cell.largeImg.image = [UIImage imageNamed:@"Default-user"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *idenCell = @"iden";
        MineProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:idenCell];
        if (cell == nil) {
            cell = [[MineProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = titleArr[indexPath.row];
        cell.field.placeholder = detailArr[indexPath.row];
        cell.field.tag = 100+indexPath.row;
        if (indexPath.row == 2) {
            cell.field.textColor = kLightTextColor;
        }
        
        NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERINFO];
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
        if (indexPath.row == 2) {
            [cell.field setEnabled:NO];
            cell.field.text = user.user_phone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.delegate = self;
            pick.sourceType = sourceType;
            pick.allowsEditing = YES;
            [self presentViewController:pick animated:YES completion:^{
                
            }];
            
            break;
        }
        case 1:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.delegate = self;
            pick.sourceType = sourceType;
            pick.allowsEditing = YES;
            [self presentViewController:pick animated:YES completion:^{
                
            }];
            
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
}


#pragma mark - Actions
- (void)onClickTopBar:(UIButton *)btn
{
    UITextField *field1 = (UITextField*)[_tableView viewWithTag:100];
    UITextField *field2 = (UITextField*)[_tableView viewWithTag:101];
    UITextField *field4 = (UITextField*)[_tableView viewWithTag:103];
    
    NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERINFO];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    NSString *userid = user.uid;
    
    if (btn.tag == BSTopBarButtonLeft) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (btn.tag == BSTopBarButtonRight) {
        
        __weak typeof(self) weakSelf = self;
        [[STHUDManager sharedManager] showHUDInView:_contentView];
        [[MineDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"POST" info:@{@"m":@"api",@"c":@"user",@"a":@"updateHandle",@"uid":userid,@"user_address":field1.text,@"user_nickname":field2.text,@"user_email":field4.text} andBlock:^(id response, NSError *error) {
            [[STHUDManager sharedManager] hideHUDInView:_contentView];
            
            if ([response isKindOfClass:[NSDictionary class]]) {
                int status = [response[@"status"] intValue];
                
                if (status == 200) {
                    KTipView(@"保存成功");
                    //请求成功，处理结果
//                    NSData *userObj = [NSKeyedArchiver archivedDataWithRootObject:user];
//                    [[NSUserDefaults standardUserDefaults] setObject:userObj forKey:kUSERINFO];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    [weakSelf outputErrorInfo:response andDefault:@"保存失败"];
                }
            }
            else
            {
                [weakSelf outputErrorInfo:nil andDefault:@"请求数据失败"];
            }
        }];
    }
}

#pragma mark - Request
//上传图片
- (void)upLoad:(UIImage*)image{
    
    [[STHUDManager sharedManager] showHUDInView:_contentView];
    
    [[MineDataHelper defaultHelper] updateImages:@[image] urlStr:@"" info:nil andBlock:^(id response, NSError *error) {
        
        [[STHUDManager sharedManager] hideHUDInView:_contentView];
        
        if ([response isKindOfClass:[NSDictionary class]]){
            BSLog(@"%@",response);
            if ([response[@"result"] boolValue]){
                
            }
        }
    }];
}

#pragma mark - 相机
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImageView *userImg = (UIImageView*)[_tableView viewWithTag:2015];
    
    //获取到照片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        userImg.image = image;
        [self performSelector:@selector(upLoad:) withObject:image afterDelay:0.2];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
