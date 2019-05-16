//
//  ScanQRcodeVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ScanQRcodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SGQRCode.h"
#import "CylinderActivationVC.h"
#import "EditCodeVC.h"
#import "Cylinder.h"
#import "CylinderInformationVC.h"

@interface ScanQRcodeVC () <SGQRCodeScanManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@end

@implementation ScanQRcodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:SetImage(@"QRCodeNavBg") forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:SetImage(@"navigationbarBackgroundBule") forBarMetrics:UIBarMetricsDefault];
    [self.scanningView removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scanQRcode];
    [self setupValue];
}

- (void)setupValue {
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {
    [self removeScanningView];
}

- (void)scanQRcode {
    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
}


- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
        [_scanningView addTarget:self action:@selector(editCodeAction)];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)setupQRCodeScanning {
    SGQRCodeScanManager *manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr];
    manager.delegate = self;
}

#pragma mark - 接口
- (void)getCylinderInfoWithNo:(NSString *)no {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/scanning"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"no"] = no;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        CylinderInfo *cylinderInfo = [CylinderInfo mj_objectWithKeyValues:json[Data]];
        switch (cylinderInfo.cylinder_status) {
            case 1:
            {
                CylinderActivationVC *cylinderActivationVc = [[CylinderActivationVC alloc] init];
                cylinderActivationVc.cylinderInfo = cylinderInfo;
                [weakSelf.navigationController pushViewController:cylinderActivationVc animated:YES];
            }
                break;
            case 2:
            {
                if (cylinderInfo.need_check == 1) {
                    if ([cylinderInfo.store_id isEqualToString:self.store_id]) {
                        [LaiMethod alertControllerWithTitle:@"年检提示" message:@"该钢瓶的年检已过期!" defaultActionTitle:@"重新年检" style:UIAlertActionStyleDefault handler:^{
                            CylinderActivationVC *cylinderActivationVc = [[CylinderActivationVC alloc] init];
                            cylinderActivationVc.cylinderInfo = cylinderInfo;
                            [weakSelf.navigationController pushViewController:cylinderActivationVc animated:YES];
                        }];
                    } else {
                        [LaiMethod alertControllerWithTitle:@"年检提示" message:@"该钢瓶的年检已过期!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                } else {
                    CylinderInformationVC *cylinderInformationVc = [[CylinderInformationVC alloc] init];
                    cylinderInformationVc.cylinderInfo = cylinderInfo;
                    [weakSelf.navigationController pushViewController:cylinderInformationVc animated:YES];
                }
            }
                break;
            case 3:
            {
                [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"查询不到该编码对应的钢瓶!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            case 4:
            {
                [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"该钢瓶已被禁用，请联系管理员!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
                break;
            case 5:
            {
                [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"该钢瓶已被暂扣，请联系管理员!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    WeakSelf(weakSelf)
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager SG_palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager SG_stopRunning];
        [scanManager SG_videoPreviewLayerRemoveFromSuperlayer];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([VerificationTool validateCylinderCode:[obj stringValue]] ) {
            [self getCylinderInfoWithNo:[obj stringValue]];
        } else {
            [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"编码错误，请扫描规范的钢瓶二维码!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    } else {
        [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"无法识别二维码!" defaultActionTitle:@"前往手动输入编码" style:UIAlertActionStyleDefault handler:^{
            EditCodeVC *editCodeVc = [[EditCodeVC alloc] init];
            [weakSelf.navigationController pushViewController:editCodeVc animated:YES];
        }];
    }
}

#pragma mark - editCodeAction
- (void)editCodeAction {
    EditCodeVC *editCodeVc = [[EditCodeVC alloc] init];
    [self.navigationController pushViewController:editCodeVc animated:YES];
}


@end
